class Domains::Paths::Show < DomainBaseAction
  include DomainMetrics
  include Period

  get "/domains/:domain_id/paths/:path" do
    referrers = get_paths_referrers

    html ShowPage, period_string: period_string, domain: domain, referrers: referrers, period: period, path: path, unique: get_unique, total: get_total, bounce: get_bounce, unique_previous: get_previous_unique, total_previous: get_previous_total, bounce_previous: get_previous_bounce
  end

  private def get_paths_referrers
    metrics(domain).get_path_referrers(path)
  end

  private def get_unique
    metrics(domain).path_unique_query(path)
  end

  private def get_total
    metrics(domain).path_total_query(path)
  end

  private def get_bounce
    metrics(domain).path_bounce_query(path)
  end

  private def get_previous_unique
    previous_metric(domain).path_unique_query(path)
  end

  private def get_previous_total
    previous_metric(domain).path_total_query(path)
  end

  private def get_previous_bounce
    previous_metric(domain).path_bounce_query(path)
  end

end
