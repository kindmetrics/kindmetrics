class Metrics
  def initialize(@domain : Domain, @period : String)
  end

  def unique_query

    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id) FROM events WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}';
    SQL
    unique = AppDatabase.run do |db|
      db.query_all sql, as: Int64
    end
    unique.first.to_s
  end

  def total_query
    EventQuery.new.domain_id(@domain.id).created_at.gt(period_days).select_count.to_s
  end

  def bounce_query
    return "0" if SessionQuery.new.domain_id(@domain.id).select_count == 0
    sql = <<-SQL
    SELECT round(sum(is_bounce * id) / sum(id) * 100) as bounce_rate
    FROM sessions WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}';
    SQL
    bounce = AppDatabase.run do |db|
      db.query_all sql, as: PG::Numeric
    end
    bounce.first.to_s
  end

  def get_days
    return [nil, nil, nil] if EventQuery.new.domain_id(@domain.id).select_count == 0
    past_time = period_days
    time_zone = @domain.time_zone
    today_date = Time.utc
    sql = <<-SQL
    SELECT DATE_TRUNC('day', created_at) AT TIME ZONE '#{time_zone}' as date, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{past_time}'
    GROUP BY DATE_TRUNC('day', created_at) AT TIME ZONE '#{time_zone}'
    ORDER BY DATE_TRUNC('day', created_at) AT TIME ZONE '#{time_zone}' asc;
    SQL
    grouped = AppDatabase.run do |db|
      db.query_all sql, as: StatsDays
    end
    grouped2 = [] of StatsDays
    range = (past_time..today_date)
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
    today_data = today[today.size-2..today.size]
    today = today[0..today.size-3].fill {|i| nil}
    today_data.each { |t| today.push t }
    return days, today, data
  end

  def get_referrers
    sql = <<-SQL
    SELECT referrer_source, COUNT(id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}'
    GROUP BY referrer_source
    ORDER BY COUNT(id) desc LIMIT 10;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsReferrer
    end
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_pages
    sql = <<-SQL
    SELECT path as address, COUNT(DISTINCT user_id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{period_days}'
    GROUP BY path
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT 10;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsPages
    end
    pages = count_percentage(pages)
    return pages
  end

  def get_countries
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

  def get_devices
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

  def get_browsers
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

  def get_os
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

  private def period_days
    case @period
    when "14d"
      return 14.days.ago
    when "30d"
      return 30.days.ago
    when "60d"
      return 60.days.ago
    when "90d"
      return 90.days.ago
    else
      return 7.days.ago
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
