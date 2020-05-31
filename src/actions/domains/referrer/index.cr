class Domains::Referrer::Index < DomainPublicBaseAction
  get "/domains/:domain_id/referrers" do
    html IndexPage, events: get_referrals, domain: domain, period: period
  end

  def get_referrals
    metrics = Metrics.new(domain, period)
    metrics.get_all_referrers
  end
end
