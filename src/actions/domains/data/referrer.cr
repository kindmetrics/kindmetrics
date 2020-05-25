class Domains::Data::Referrer < DomainBaseAction
  get "/domains/:domain_id/data/referrer" do
    html ReferrerPage, domain: domain, referrers: get_referrers(domain)
  end

  def get_referrers(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_referrers
  end
end
