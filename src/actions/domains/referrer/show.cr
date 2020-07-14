class Domains::Referrer::Show < DomainBaseAction
  get "/domains/:domain_id/referrers/:source" do
    domains = DomainQuery.new.user_id(current_user.id)
    html ShowPage, domain: domain, total: get_total, events: get_referrals, source: parse_source, period: period, domains: domains
  end

  def get_referrals
    metrics = Metrics.new(domain, period)
    metrics.get_source_referrers(parse_source)
  end

  def get_total
    metrics = Metrics.new(domain, period)
    metrics.get_source_referrers_total(parse_source)
  end

  def parse_source
    URI.decode(source).sub("+", " ")
  end
end
