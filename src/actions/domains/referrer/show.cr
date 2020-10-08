class Domains::Referrer::Show < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/referrers/:source" do
    domains = DomainQuery.new.user_id(current_user.id)
    html ShowPage, domain: domain, total: get_total, events: get_referrals, source: parse_source, from: real_from, to: real_to, period: period, domains: domains
  end

  def get_referrals
    new_metrics.get_referrers(0)
  end

  def get_total
    new_metrics.get_source_referrers_total
  end

  def parse_source
    URI.decode(source).sub("+", " ")
  end

  def new_metrics
    Metrics.new(domain, real_from, real_to, goal, site_path, source, medium_name)
  end
end
