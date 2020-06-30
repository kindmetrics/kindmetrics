class MetricsNew
  def initialize(@domain : Domain, @from_date : Time, @to_date : Time)
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
  end

  def current_query : Int64
    sql = <<-SQL
      SELECT COUNT(*) FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND length IS NULL
    SQL
    res = @client.execute(sql)
    res.map(current: UInt64).first["current"].to_i64
  end

  def unique_query : Int64
    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{@from_date.to_s("%Y-%m-%d %H:%M:%S")}') AND created_at < toDateTime('#{@to_date.to_s("%Y-%m-%d %H:%M:%S")}')
    SQL
    res = @client.execute(sql)
    res.map(unique: UInt64).first["unique"].to_i64
  end

  def path_unique_query(path : String) : Int64
    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id) FROM kindmetrics.events WHERE domain_id='#{@domain.id}' AND created_at > toDateTime('#{@from_date.to_s("%Y-%m-%d %H:%M:%S")}') AND created_at < toDateTime('#{@to_date.to_s("%Y-%m-%d %H:%M:%S")}') AND (path='#{path}' OR path='/#{path}');
    SQL
    res = @client.execute(sql)
    res.map(unique: Int64).first["unique"]
  end

  def path_total_query(path : String) : Int64
    EventQuery.new.domain_id(@domain.id).created_at.gt(@from_date).created_at.lt(@to_date).where("path='#{path}' or path='/#{path}'").select_count
  end

  def path_bounce_query(path : String) : Int64
    return 0.to_i64 if SessionQuery.new.domain_id(@domain.id).select_count == 0
    sql = <<-SQL
    SELECT round(sum(is_bounce * id) / sum(id) * 100) as bounce_rate
    FROM sessions WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}' AND (path='#{path}' OR path='/#{path}');
    SQL
    bounce = AppDatabase.run do |db|
      db.query_all sql, as: PG::Numeric | Nil
    end
    return 0.to_i64 if bounce.first.nil?
    bounce.first.not_nil!.to_s.to_i64
  end

  def path_referrers(path : String) : Array(StatsReferrer)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, COUNT(DISTINCT user_id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}' AND (path='#{path}' OR path='/#{path}')
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT 10;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsReferrer
    end
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def total_query : Int64
    sql = <<-SQL
    SELECT COUNT(*) FROM kindmetrics.events WHERE domain_id=#{@domain.id} AND created_at > toDateTime('#{@from_date.to_s("%Y-%m-%d %H:%M:%S")}') AND created_at < toDateTime('#{@to_date.to_s("%Y-%m-%d %H:%M:%S")}')
    SQL
    res = @client.execute(sql)
    res.map(total: UInt64).first["total"].to_i64
  end

  def bounce_query : Int64
    return 0.to_i64 if SessionQuery.new.domain_id(@domain.id).select_count == 0
    sql = <<-SQL
    SELECT round(sum(is_bounce * id) / sum(id) * 100) as bounce_rate
    FROM sessions WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}';
    SQL
    bounce = AppDatabase.run do |db|
      db.query_all sql, as: PG::Numeric | Nil
    end
    return 0.to_i64 if bounce.first.nil?
    bounce.first.not_nil!.to_s.to_i64
  end

  def get_referrers(limit : Int32 = 10) : Array(StatsReferrer)
    sql = <<-SQL
    SELECT referrer_source, MIN(referrer_domain) as referrer_domain, COUNT(DISTINCT user_id) as count FROM events
    WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}'
    GROUP BY referrer_source
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT #{limit};
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsReferrer
    end
    pages.reject! { |r| r.referrer_source.nil? }
    pages = count_percentage(pages)
    return pages
  end

  def get_pages : Array(StatsPages)
    sql = <<-SQL
    SELECT path as address, COUNT(DISTINCT user_id) as count FROM sessions
    WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}'
    GROUP BY path
    ORDER BY COUNT(DISTINCT user_id) desc LIMIT 10;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsPages
    end
    pages = count_percentage(pages)
    return pages
  end

  private def count_percentage(array)
    total = array.sum { |p| p.count }
    array.map do |p|
      p.percentage = p.count / total.to_f32
      p
    end
  end
end
