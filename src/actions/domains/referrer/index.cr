class Domains::Referrer::Index < DomainBaseAction
  get "/domains/:domain_id/referrers" do
    html IndexPage, events: get_referrals, domain: domain
  end

  def get_referrals
    metrics = Metrics.new(domain, "7d")
    metrics.get_all_referrers
  end
end
