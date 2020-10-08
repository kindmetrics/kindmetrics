class Domains::Referrer::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/referrers" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, referrers: get_referrals, mediums: get_mediums, domain: domain, from: real_from, to: real_to, period: period, domains: domains
  end

  def get_referrals
    metrics.get_sources(0)
  end

  def get_mediums
    metrics.get_all_medium_referrers
  end
end
