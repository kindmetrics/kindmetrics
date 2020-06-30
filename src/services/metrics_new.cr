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
    SELECT COUNT(DISTINCT user_id) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}')
    SQL
    res = @client.execute(sql)
    res.map(unique: UInt64).first["unique"].to_i64
  end

  def path_unique_query(path : String) : Int64
    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}') AND (path='#{path}' OR path='/#{path}')
    SQL
    res = @client.execute(sql)
    res.map(unique: UInt64).first["unique"].to_i64
  end

  def path_total_query(path : String) : Int64
    EventQuery.new.domain_id(@domain.id).created_at.gt(@from_date).created_at.lt(@to_date).where("path='#{path}' or path='/#{path}'").select_count
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
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, COUNT(DISTINCT user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND (path='#{path}' OR path='/#{path}')
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT 10
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
    SELECT round(sum(is_bounce * id) / sum(id) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_f?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def get_referrers(limit : Int32 = 10)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, COUNT(DISTINCT user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT #{limit}
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_source_referrers(source : String)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer) as referrer_domain, COUNT(DISTINCT user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{source}'
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_all_referrers
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, COUNT(DISTINCT user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_path_referrers(path : String)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer) as referrer_domain, COUNT(DISTINCT user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND (path='#{path}' OR path='/#{path}')
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_days
    return [nil, nil, nil] if total_query == 0
    sql = <<-SQL
    SELECT toDate(created_at) as date, COUNT(id) as count FROM kindmetrics.events
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

  def get_pages
    sql = <<-SQL
    SELECT path as address, COUNT(DISTINCT user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY path
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT 10
    SQL
    res = @client.execute(sql)
    pp! res
    json = res.map_nil(address: String, count: UInt64).to_json
    return [] of StatsPages if json.nil?
    pages = Array(StatsPages).from_json(json)
    pages = count_percentage(pages)
    return pages
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
end
