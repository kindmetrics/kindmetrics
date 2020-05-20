class Domains::Show < BrowserAction
  param period : String = "7d"

  route do
    domain = DomainQuery.find(domain_id)
    html ShowPage, domain: domain, total_unique: unique_query(domain), total_sum: total_query(domain), period: period, events: EventQuery.new.domain_id(domain_id)
  end

  def unique_query(domain)
    metrics = Metrics.new(domain, period)
    metrics.unique_query
  end

  def total_query(domain)
    metrics = Metrics.new(domain, period)
    metrics.total_query
  end
end
