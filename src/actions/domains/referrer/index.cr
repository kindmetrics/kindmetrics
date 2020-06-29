class Domains::Referrer::Index < DomainBaseAction
  get "/domains/:domain_id/referrers" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, events: get_referrals, domain: domain, period: period, domains: domains
  end

  def get_referrals
    metrics = Metrics.new(domain, period)
    metrics.get_all_referrers
  end
end
