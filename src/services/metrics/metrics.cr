class Metrics
  include Percentage
  include ClickDates

  def initialize(@domain : Domain, @from_date : Time, @to_date : Time, @goal : Goal? = nil, @path : String? = nil, @source : String? = nil, @medium : String? = nil, @country : String? = nil, @browser : String? = nil)
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
  end

  def current_query : Int64
    sql = <<-SQL
      SELECT COUNT(*) FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND length IS NULL
    SQL
    res = @client.execute(sql)
    res.map(current: UInt64).first["current"].not_nil!.to_i64
  end

  def real_count : Int64
    sql = <<-SQL
    SELECT COUNT(*) FROM kindmetrics.events WHERE domain_id=#{@domain.id}
    SQL
    res = @client.execute(sql)
    res.map(total: UInt64).first["total"].to_i64
  end

  def unique_query : Int64
    sql = <<-SQL
    SELECT uniq(user_id) FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}')
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    SQL
    res = @client.execute(sql)
    res.map(unique: UInt64).first["unique"].to_i64
  end

  def total_query : Int64
    sql = <<-SQL
    SELECT COUNT(*) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{slim_from_date}') AND created_at < toDateTime('#{slim_to_date}')
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    SQL
    res = @client.execute(sql)
    res.map(total: UInt64).first["total"].to_i64
  end

  def bounce_query : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def avg_length : Int64
    sql = <<-SQL
    SELECT avg(length) as avg_length
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    SQL
    res = @client.execute(sql)
    avg_length = res.data.first.first.as_f?
    return 0_i64 if avg_length.nil?
    avg_length.not_nil!.to_i64
  end

  def bounce_query_referrer(referrer_source : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{referrer_source}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def bounce_query_medium(referrer_medium : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_medium='#{referrer_medium}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  def get_source_referrers_total : Int64
    sql = <<-SQL
    SELECT uniq(user_id) as total FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY referrer_source
    ORDER BY total desc
    SQL
    res = @client.execute(sql)
    return 0_i64 if res.records.size == 0
    res.map(total: UInt64).first["total"].to_i64
  end

  def get_sources(limit : Int32 = 6)
    sql = <<-SQL
    SELECT referrer_source, any(referrer_domain) as referrer_domain, any(referrer_medium) as referrer_medium, COUNT(*) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source IS NOT NULL
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY referrer_source
    ORDER BY count desc #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_source: String, referrer_domain: String, referrer_medium: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages = count_percentage(pages)
    count_bounce_rate(pages)
  end

  def get_referrers(limit : Int32 = 6)
    sql = <<-SQL
    SELECT referrer as referrer_url, any(referrer_domain) as referrer_domain, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY referrer_url
    ORDER BY count desc #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_url: String, referrer_domain: String, count: UInt64).to_json
    return [] of StatsReferrer if json.nil?
    pages = Array(StatsReferrer).from_json(json)
    pages = count_percentage(pages)
    count_bounce_rate(pages)
  end

  def get_all_medium_referrers : Array(StatsMediumReferrer)
    sql = <<-SQL
    SELECT referrer_medium, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_medium IS NOT NULL
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY referrer_medium
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(referrer_medium: String, count: UInt64).to_json
    return [] of StatsMediumReferrer if json.nil?
    pages = Array(StatsMediumReferrer).from_json(json)
    pages = count_percentage(pages)
    count_medium_bounce_rate(pages)
  end

  def get_days
    return [nil, nil] if total_query == 0
    sql = <<-SQL
    SELECT toDate(created_at) as date, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
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
    return days, data
  end

  def get_page_speeds
    return [nil, nil] if total_query == 0
    sql = <<-SQL
    SELECT toDate(created_at) as date, avg(page_load) as page_loader FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND page_load > 0
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY toDate(created_at)
    ORDER BY toDate(created_at) asc
    SQL
    res = @client.execute(sql)
    grouped_json = res.map_nil(date: Time, page_load_sec: Float64).to_json
    grouped = Array(StatsPageSpeed).from_json(grouped_json)
    grouped2 = [] of StatsPageSpeed
    range = (@from_date..@to_date)
    range.each do |e|
      date = nil
      grouped.each do |g|
        if e.day == g.date.day && e.month == g.date.month
          date = StatsPageSpeed.new(date: e, page_load_sec: g.page_load_sec.not_nil! / 1000)
        end
      end
      date = StatsPageSpeed.new(date: e, page_load_sec: 0.0_f64) if date.nil?
      grouped2 << date.not_nil! unless date.nil?
    end
    days = grouped2.map { |d| d.date }
    data = grouped2.map { |d| d.page_load_sec.try(&.round(3)) }
    return days, data
  end

  def get_pagespeed_path(limit : Int32 = 6) : Array(StatsPagespeedPath)
    sql = <<-SQL
    SELECT path as address, avg(page_load) as page_loader FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND page_load > 0
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY path
    ORDER BY page_loader ASC #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute(sql)
    grouped_json = res.map_nil(address: String, page_load: Float64).to_json
    return [] of StatsPagespeedPath if res.nil?
    pages = Array(StatsPagespeedPath).from_json(grouped_json)
  end

  def get_pagespeed_country(limit : Int32 = 6) : Array(StatsPagespeedCountry)
    sql = <<-SQL
    SELECT country, avg(page_load) as page_loader FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND page_load > 0 AND country IS NOT NULL
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY country
    ORDER BY page_loader ASC #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute(sql)
    grouped_json = res.map_nil(country: String, page_load: Float64).to_json
    return [] of StatsPagespeedCountry if res.nil?
    countries = Array(StatsPagespeedCountry).from_json(grouped_json)
    cc2country = IP2Country::CC2Country.new
    countries.map do |c|
      next c if c.country.nil?
      c.country_name = cc2country.lookup(c.country.not_nil!, "en")
      next c
    end
  end

  def get_pageviews_days
    return [nil, nil] if total_query == 0
    sql = <<-SQL
    SELECT toDate(created_at) as date, count(*) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
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
    return days, data
  end

  def get_pages(limit : Int32 = 6) : Array(StatsPages)
    sql = <<-SQL
    SELECT path as address, uniq(user_id) as count FROM kindmetrics.events
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY path
    ORDER BY count desc #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsPages if res.nil?
    pages = Array(StatsPages).from_json(res)
    count_percentage(pages)
  end

  def get_entry_pages(limit : Int32 = 6) : Array(StatsPages)
    sql = <<-SQL
    SELECT path as address, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY path
    ORDER BY count desc #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsPages if res.nil?
    pages = Array(StatsPages).from_json(res)
    count_percentage(pages)
  end

  def get_countries(limit : Int32 = 6) : Array(StatsCountry)
    sql = <<-SQL
    SELECT country, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND country IS NOT NULL
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY country
    ORDER BY count desc #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsCountry if res.nil?
    countries = Array(StatsCountry).from_json(res)
    cc2country = IP2Country::CC2Country.new
    countries = count_percentage(countries)
    countries.map do |c|
      next c if c.country.nil?
      c.country_name = cc2country.lookup(c.country.not_nil!, "en")
      next c
    end
  end

  def get_languages(limit : Int32 = 6) : Array(StatsLanguage)
    sql = <<-SQL
    SELECT language, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND language IS NOT NULL
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY language
    ORDER BY count desc #{limit > 0 ? "LIMIT #{limit}" : nil}
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsLanguage if res.nil?
    languages = Array(StatsLanguage).from_json(res)
    languages = languages.map do |l|
      next l if l.language.nil?
      lang_info = LanguageList::LanguageInfo.find_by_iso_639_1(l.language)
      l.language_name = lang_info.common_name
      next l
    end
    languages = count_percentage(languages)
    languages
  end

  def get_countries_map : Array(StatsCountry)?
    return nil if total_query == 0
    sql = <<-SQL
    SELECT country, uniq(user_id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY country
    ORDER BY count asc
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsCountry if res.nil?
    Array(StatsCountry).from_json(res)
  end

  def get_devices : Array(StatsDevice)
    sql = <<-SQL
    SELECT device, COUNT(id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY device
    ORDER BY COUNT(id) desc LIMIT 6
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsDevice if res.nil?
    devices = Array(StatsDevice).from_json(res)
    count_percentage(devices)
  end

  def get_browsers : Array(StatsBrowser)
    sql = <<-SQL
    SELECT browser_name as browser, COUNT(id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND browser_name IS NOT NULL AND browser_name!=''
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY browser_name
    ORDER BY COUNT(id) desc LIMIT 6
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsBrowser if res.nil?
    browsers = Array(StatsBrowser).from_json(res)
    count_percentage(browsers)
  end

  def get_os : Array(StatsOS)
    sql = <<-SQL
    SELECT operative_system, COUNT(id) as count FROM kindmetrics.sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND operative_system IS NOT NULL AND operative_system!=''
    #{where_goal_string}
    #{where_path_string}
    #{where_source_string}
    #{where_medium_string}
    #{where_country_string}
    #{where_browser_string}
    GROUP BY operative_system
    ORDER BY COUNT(id) desc LIMIT 6
    SQL
    res = @client.execute_as_json(sql)
    return [] of StatsOS if res.nil?
    os = Array(StatsOS).from_json(res)
    count_percentage(os)
  end

  def bounce_query_path_referrer(referrer_source : String, path : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND referrer_source='#{referrer_source}' AND (path='#{path}' OR path='/#{path}')
    #{where_goal_string}
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end

  private def where_goal_string
    return if @goal.nil?

    if @goal.not_nil!.kind == 0
      "AND name=#{PG::EscapeHelper.escape_literal(@goal.not_nil!.name)}"
    else
      "AND path=#{PG::EscapeHelper.escape_literal(@goal.not_nil!.name)}"
    end
  end

  private def where_path_string
    return if @path.nil?

    "AND path=#{PG::EscapeHelper.escape_literal(@path.not_nil!.strip)}"
  end

  private def where_source_string
    return if @source.nil?

    "AND referrer_source=#{PG::EscapeHelper.escape_literal(@source.not_nil!.strip)}"
  end

  private def where_medium_string
    return if @medium.nil?

    "AND referrer_medium=#{PG::EscapeHelper.escape_literal(@medium.not_nil!.strip)}"
  end

  private def where_country_string
    return if @country.nil?

    "AND country=#{PG::EscapeHelper.escape_literal(@country.not_nil!.strip)}"
  end

  private def where_browser_string
    return if @browser.nil?

    "AND browser_name=#{PG::EscapeHelper.escape_literal(@browser.not_nil!.strip)}"
  end
end
