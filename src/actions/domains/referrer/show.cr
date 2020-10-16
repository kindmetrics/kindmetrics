class Domains::Referrer::Show < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/referrers/:source_name" do
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
    return nil if source_name.nil?
    URI.decode(source_name.not_nil!).sub("+", " ")
  end

  def new_metrics
    Metrics.new(domain, real_from, real_to, goal, site_path, source_name, medium)
  end
end
