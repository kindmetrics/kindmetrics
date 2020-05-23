class Domains::Show < BrowserAction
  param period : String = "7d"

  route do
    domain = DomainQuery.find(domain_id)
    domains = DomainQuery.new.user_id(current_user.id)
    if current_user.current_domain_id != domain.id
      SaveUser.update!(current_user, current_domain_id: domain.id)
    end
    html ShowPage, domain: domain, total_unique: unique_query(domain), total_sum: total_query(domain), period: period, period_string: period_string, sessions: SessionQuery.new.domain_id(domain_id), domains: domains
  end

  def unique_query(domain)
    metrics = Metrics.new(domain, period)
    metrics.unique_query
  end

  def total_query(domain)
    metrics = Metrics.new(domain, period)
    metrics.total_query
  end

  def period_string
    case period
    when "14d"
      return "14 days"
    when "30d"
      return "30 days"
    when "60d"
      return "60 days"
    when "90d"
      return "90 days"
    else
      return "7 days"
    end
  end
end
