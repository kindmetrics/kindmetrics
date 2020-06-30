class Metrics
  def initialize(@domain : Domain, @period : String)
    @new_metrics = MetricsNew.new(@domain, period_days, Time.local.at_end_of_day)
  end

  delegate :current_query, :unique_query, :total_query, :bounce_query, :get_referrers, :get_source_referrers, :get_pages, to: @new_metrics
  delegate :path_total_query, :path_unique_query, :get_all_referrers, :get_path_referrers, :path_bounce_query, :get_days, to: @new_metrics

  def get_countries_map : Array(StatsCountry)?
    return nil if EventQuery.new.domain_id(@domain.id).select_count == 0
    past_time = period_days
    time_zone = @domain.time_zone
    today_date = Time.utc
    sql = <<-SQL
    SELECT country, COUNT(DISTINCT user_id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{past_time}'
    GROUP BY country
    ORDER BY COUNT(DISTINCT user_id) asc;
    SQL
    country = AppDatabase.run do |db|
      db.query_all sql, as: StatsCountry
    end
    country
  end

  def get_source_referrers_total(source : String) : String
    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id) FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}' AND referrer_source='#{source}'
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: Int64
    end
    return pages.first.to_s
  end

  def get_countries : Array(StatsCountry)
    sql = <<-SQL
    SELECT country, COUNT(DISTINCT user_id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}'
    GROUP BY country
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT 10;
    SQL
    countries = AppDatabase.run do |db|
      db.query_all sql, as: StatsCountry
    end
    cc2country = IP2Country::CC2Country.new
    countries = count_percentage(countries)
    countries.map! do |c|
      next c if c.country.nil?
      c.country_name = cc2country.lookup(c.country.not_nil!, "en")
      next c
    end
    return countries
  end

  def get_devices : Array(StatsDevice)
    sql = <<-SQL
    SELECT device, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}'
    GROUP BY device
    ORDER BY COUNT(id) desc LIMIT 10;
    SQL
    devices = AppDatabase.run do |db|
      db.query_all sql, as: StatsDevice
    end
    devices = count_percentage(devices)
    return devices
  end

  def get_browsers : Array(StatsBrowser)
    sql = <<-SQL
    SELECT browser_name as browser, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}'
    GROUP BY browser_name
    ORDER BY COUNT(id) desc LIMIT 10;
    SQL
    browsers = AppDatabase.run do |db|
      db.query_all sql, as: StatsBrowser
    end
    browsers = count_percentage(browsers)
    return browsers
  end

  def get_os : Array(StatsOS)
    sql = <<-SQL
    SELECT operative_system, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}'
    GROUP BY operative_system
    ORDER BY COUNT(id) desc LIMIT 10;
    SQL
    browsers = AppDatabase.run do |db|
      db.query_all sql, as: StatsOS
    end
    browsers = count_percentage(browsers)
    return browsers
  end

  private def period_days : Time
    case @period
    when "14d"
      return 14.days.ago.at_beginning_of_day
    when "30d"
      return 30.days.ago.at_beginning_of_day
    when "60d"
      return 60.days.ago.at_beginning_of_day
    when "90d"
      return 90.days.ago.at_beginning_of_day
    else
      return 7.days.ago.at_beginning_of_day
    end
  end

  private def count_percentage(array)
    total = array.sum { |p| p.count }
    array.map do |p|
      p.percentage = p.count / total.to_f32
      p
    end
  end
end
