class MetricsNew
  def initialize(@domain : Domain, @from_date : Time, @to_date : Time)
  end

  def current_query : String
    SessionQuery.new.domain_id(@domain.id).length.is_nil.select_count.to_s
  end

  def unique_query : String
    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id) FROM events WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}';
    SQL
    unique = AppDatabase.run do |db|
      db.query_all sql, as: Int64
    end
    unique.first.to_s
  end

  def total_query : String
    EventQuery.new.domain_id(@domain.id).created_at.gt(@from_date).created_at.lt(@to_date).select_count.to_s
  end

  def bounce_query : String
    return "0" if SessionQuery.new.domain_id(@domain.id).select_count == 0
    sql = <<-SQL
    SELECT round(sum(is_bounce * id) / sum(id) * 100) as bounce_rate
    FROM sessions WHERE domain_id=#{@domain.id} AND created_at > '#{@from_date}' AND created_at < '#{@to_date}';
    SQL
    bounce = AppDatabase.run do |db|
      db.query_all sql, as: PG::Numeric
    end
    bounce.first.to_s
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
