class Domains::Show < DomainBaseAction
  route do
    domains = DomainQuery.new.user_id(current_user.id)
    if current_user.current_domain_id != domain.id
      SaveUser.update!(current_user, current_domain_id: domain.id)
    end
    html ShowPage, domain: domain, total_unique: unique_query(domain), total_bounce: bounce_query(domain), total_sum: total_query(domain), period: period, period_string: period_string, sessions: SessionQuery.new.domain_id(domain_id), domains: domains
  end

  def unique_query(domain)
    metrics(domain).unique_query
  end

  def total_query(domain)
    metrics(domain).total_query
  end

  def bounce_query(domain)
    metrics(domain).bounce_query
  end

  def metrics(domain)
    @metrics ||= Metrics.new(domain, period)
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
