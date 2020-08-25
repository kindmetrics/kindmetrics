class Domains::Referrer::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/referrers" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, referrers: get_referrals, mediums: get_mediums, domain: domain, period: period, domains: domains
  end

  def get_referrals
    metrics = Metrics.new(domain, period)
    metrics.get_all_referrers
  end

  def get_mediums
    metrics = Metrics.new(domain, period)
    metrics.get_all_medium_referrers
  end
end
