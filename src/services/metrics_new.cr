class MetricsNew
  def initialize(@domain : Domain, @from_date : Time, @to_date : Time)
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
  end

  def current_query : Int64
    sql = <<-SQL
      SELECT COUNT(*) FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND length IS NULL
    SQL
    res = @client.execute(sql)
    res.map(current: UInt64).first["current"].not_nil!.to_i64
  end

  def unique_query : Int64
    sql = <<-SQL
    SELECT uniq(user_id) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}')
    SQL
    res = @client.execute(sql)
    res.map(unique: UInt64).first["unique"].to_i64
  end

  def path_unique_query(path : String) : Int64
    sql = <<-SQL
    SELECT uniq(user_id) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}') AND (path='#{path}' OR path='/#{path}')
    SQL
    res = @client.execute(sql)
    res.map(unique: UInt64).first["unique"].to_i64
  end

  def path_total_query(path : String) : Int64
    sql = <<-SQL
    SELECT COUNT(*) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}') AND (path='#{path}' OR path='/#{path}')
    SQL
    res = @client.execute(sql)
    res.map(total: UInt64).first["total"].to_i64
  end

  def path_bounce_query(path : String) : Int64
    return 0.to_i64 if total_query == 0
    sql = <<-SQL
    SELECT round(sum(is_bounce * id) / sum(id) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND (path='#{path}' OR path='/#{path}')
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_f?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def path_referrers(path : String) : Array(StatsReferrer)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND (path='#{path}' OR path='/#{path}')
    GROUP BY referrer_source
    ORDER BY count desc LIMIT 10
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def total_query : Int64
    sql = <<-SQL
    SELECT COUNT(*) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}')
    SQL
    res = @client.execute(sql)
    res.map(total: UInt64).first["total"].to_i64
  end

  def bounce_query : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def bounce_query_referrer(referrer_source : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{referrer_source}'
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def bounce_query_path_referrer(referrer_source : String, path : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{referrer_source}' AND (path='#{path}' OR path='/#{path}')
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def bounce_query_medium(referrer_medium : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_medium='#{referrer_medium}'
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def get_source_referrers_total(source : String) : Int64
    sql = <<-SQL
    SELECT uniq(user_id) as total FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{source}'
    GROUP BY referrer_source
    ORDER BY total desc
    SQL
    res = @client.execute(sql)
    return 0_i64 if res.records.size == 0
    res.map(total: UInt64).first["total"].to_i64
  end

  def get_referrers(limit : Int32 = 10)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, MIN(referrer_medium) as referrer_medium, COUNT(*) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY referrer_source
    ORDER BY count desc LIMIT #{limit}
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, referrer_medium: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_source_referrers(source : String)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer) as referrer_url, COUNT(id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{source}' AND referrer IS NOT NULL
    GROUP BY referrer_source
    ORDER BY uniq(user_id) desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_url: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    pages = count_bounce_rate(pages)
    return pages
  end

  def get_all_referrers : Array(StatsReferrer)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY referrer_source
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    pages = count_bounce_rate(pages)
    return pages
  end

  def get_path_referrers(path : String) : Array(StatsReferrer)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, MIN(referrer) as referrer_url, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND (path='#{path}' OR path='/#{path}') AND referrer IS NOT NULL
    GROUP BY referrer_source
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, referrer_url: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    pages = count_path_bounce_rate(pages, path)
    return pages
  end

  def get_all_medium_referrers : Array(StatsMediumReferrer)
    sql = <<-SQL
    SELECT referrer_medium, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY referrer_medium
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_medium: String, count: UInt64).to_json
    return [] of StatsMediumReferrer if json.nil?
    pages = Array(StatsMediumReferrer).from_json(json)
    pages.reject! { |r| r.referrer_medium.nil? }
    pages = count_percentage(pages)
    pages = count_medium_bounce_rate(pages)
    return pages
  end

  def get_path_medium_referrers(path : String) : Array(StatsMediumReferrer)
    sql = <<-SQL
    SELECT referrer_medium, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND (path='#{path}' OR path='/#{path}') AND referrer IS NOT NULL
    GROUP BY referrer_medium
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, count: UInt64).to_json
    return [] of StatsMediumReferrer if json.nil?
    pages = Array(StatsMediumReferrer).from_json(json)
    pages.reject! { |r| r.referrer_medium.nil? }
    pages = count_percentage(pages)
    pages = count_medium_bounce_rate(pages)
    return pages
  end

  def get_days
    return [nil, nil, nil] if total_query == 0
    sql = <<-SQL
    SELECT toDate(created_at) as date, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY toDate(created_at)
    ORDER BY toDate(created_at) asc
    SQL
    res = @client.execute(sql)
    grouped_json = res.map_nil(date: Time, count: UInt64).to_json
    grouped = Array(StatsDays).from_json(grouped_json)
    grouped2 = [] of StatsDays
    range = (@from_date..@to_date)
    range.each do |e|
      date = nil
      grouped.each do |g|
        if e.day == g.date.day && e.month == g.date.month
          date = StatsDays.new(date: e, count: g.count.not_nil!)
        end
      end
      date = StatsDays.new(date: e, count: 0) if date.nil?
      grouped2 << date.not_nil! unless date.nil?
    end
    days = grouped2.map { |d| d.date }
    data = grouped2.map { |d| d.count }
    today = data.clone
    data.pop
    today_data = today[today.size - 2..today.size]
    today = today[0..today.size - 3].fill { |i| nil }
    today_data.each { |t| today.push t }
    return days, today, data
  end

  def get_pages : Array(StatsPages)
    sql = <<-SQL
    SELECT path as address, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY path
    ORDER BY count desc LIMIT 10
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsPages if res.nil?
    pages = Array(StatsPages).from_json(res)
    pages = count_percentage(pages)
    return pages
  end

  def get_countries : Array(StatsCountry)
    sql = <<-SQL
    SELECT country, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY country
    ORDER BY count desc LIMIT 10
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsCountry if res.nil?
    countries = Array(StatsCountry).from_json(res)
    cc2country = IP2Country::CC2Country.new
    countries = count_percentage(countries)
    countries.map! do |c|
      next c if c.country.nil?
      c.country_name = cc2country.lookup(c.country.not_nil!, "en")
      next c
    end
    return countries
  end

  def get_countries_map : Array(StatsCountry)?
    return nil if total_query == 0
    sql = <<-SQL
    SELECT country, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY country
    ORDER BY count asc
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsCountry if res.nil?
    Array(StatsCountry).from_json(res)
  end

  def get_devices : Array(StatsDevice)
    sql = <<-SQL
    SELECT device, COUNT(id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY device
    ORDER BY COUNT(id) desc LIMIT 10
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsDevice if res.nil?
    devices = Array(StatsDevice).from_json(res)
    count_percentage(devices)
  end

  def get_browsers : Array(StatsBrowser)
    sql = <<-SQL
    SELECT browser_name as browser, COUNT(id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND browser_name IS NOT NULL
    GROUP BY browser_name
    ORDER BY COUNT(id) desc LIMIT 10
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsBrowser if res.nil?
    browsers = Array(StatsBrowser).from_json(res)
    browsers.reject! { |r| r.browser.nil? }
    count_percentage(browsers)
  end

  def get_os : Array(StatsOS)
    sql = <<-SQL
    SELECT operative_system, COUNT(id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND operative_system IS NOT NULL
    GROUP BY operative_system
    ORDER BY COUNT(id) desc LIMIT 10
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsOS if res.nil?
    os = Array(StatsOS).from_json(res)
    os.reject! { |r| r.operative_system.nil? }
    count_percentage(os)
  end

  private def slim_from_date
    @from_date.to_s("%Y-%m-%d %H:%M:%S")
  end

  private def slim_to_date
    @to_date.to_s("%Y-%m-%d %H:%M:%S")
  end

  private def count_percentage(array)
    total = array.sum { |p| p.count }
    array.map do |p|
      p.percentage = p.count / total.to_f32
      p
    end
  end

  private def count_bounce_rate(array)
    array.map do |p|
      next p if p.referrer_source.nil?
      p.bounce_rate = bounce_query_referrer(p.referrer_source.not_nil!)
      p
    end
  end

  private def count_path_bounce_rate(array, path)
    array.map do |p|
      next p if p.referrer_source.nil?
      p.bounce_rate = bounce_query_path_referrer(p.referrer_source.not_nil!, path)
      p
    end
  end

  private def count_medium_bounce_rate(array)
    array.map do |p|
      next p if p.referrer_medium.nil?
      p.bounce_rate = bounce_query_medium(p.referrer_medium.not_nil!)
      p
    end
  end
end
