class Domains::Paths::Show < DomainBaseAction
  include DomainMetrics
  include Period

  get "/domains/:domain_id/paths/:path" do
    referrers = get_paths_referrers

    html ShowPage, domain: domain, referrers: referrers, period: period, path: path
  end

  def get_paths_referrers
    metrics = Metrics.new(domain, period)
    metrics.get_path_referrers(path)
  end
end
