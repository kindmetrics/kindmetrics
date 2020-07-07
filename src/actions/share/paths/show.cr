class Share::Paths::Show < BrowserAction
  include Auth::AllowGuests
  include Hashid
  include DomainMetrics
  include Period

  param period : String = "7d"

  get "/share/:share_id/paths/:path" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    referrers = get_paths_referrers(domain)
    mediums = get_paths_mediums(domain)

    html Domains::Paths::ShowPage, share_page: true, period_string: period_string, domain: domain, referrers: referrers, mediums: mediums, period: period, path: path, unique: get_unique(domain), total: get_total(domain), bounce: get_bounce(domain), unique_previous: get_previous_unique(domain), total_previous: get_previous_total(domain), bounce_previous: get_previous_bounce(domain)
  end

  private def get_paths_referrers(domain : Domain)
    metrics(domain).get_path_referrers(path)
  end

  private def get_paths_mediums(domain : Domain)
    metrics(domain).get_path_medium_referrers(path)
  end

  private def get_unique(domain : Domain)
    metrics(domain).path_unique_query(path)
  end

  private def get_total(domain : Domain)
    metrics(domain).path_total_query(path)
  end

  private def get_bounce(domain : Domain)
    metrics(domain).path_bounce_query(path)
  end

  private def get_previous_unique(domain : Domain)
    previous_metric(domain).path_unique_query(path)
  end

  private def get_previous_total(domain : Domain)
    previous_metric(domain).path_total_query(path)
  end

  private def get_previous_bounce(domain : Domain)
    previous_metric(domain).path_bounce_query(path)
  end
end
