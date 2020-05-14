class Domains::Show < BrowserAction
  route do
    domain = DomainQuery.find(domain_id)
    html ShowPage, domain: domain, total_unique: unique_query(domain), total_sum: total_query(domain), events: EventQuery.new.domain_id(domain_id)
  end

  def unique_query(domain)
    sql = <<-SQL
    SELECT COUNT(DISTINCT user_id)  FROM events WHERE domain_id=#{domain.id} AND created_at > '#{30.days.ago}';
    SQL
    unique = AppDatabase.run do |db|
      db.query_all sql, as: Int64
    end
    unique.first.to_s
  end

  def total_query(domain)
    EventQuery.new.domain_id(domain.id).created_at.gt(30.days.ago).select_count.to_s
  end
end
