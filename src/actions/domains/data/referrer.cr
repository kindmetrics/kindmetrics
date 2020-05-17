class Domains::Data::Referrer < BrowserAction
  get "/domains/:domain_id/data/referrer" do
    domain = DomainQuery.find(domain_id)
    html ReferrerPage, domain: domain, referrers: get_referrers(domain)
  end

  def get_referrers(domain)
    metrics = Metrics.new(domain)
    metrics.get_referrers
  end
end
