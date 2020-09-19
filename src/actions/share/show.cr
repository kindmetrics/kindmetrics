class Share::Show < BrowserAction
  include Auth::AllowGuests
  include Hashid
  include Period
  include PreviousDomainMetrics

  param period : String = "7d"
  param goal_id : Int64 = 0_i64
  param site_path : String = ""
  param source_name : String = ""
  param medium_name : String = ""

  before require_domain
  @domain : Domain?

  get "/share/:share_id" do
    html Domains::ShowPage, domain: domain, goal: goal, source: source_name, medium: medium_name, site_path: site_path, share_page: true, total_unique: metrics.unique_query, total_unique_previous: previous_metric.unique_query, total_bounce: metrics.bounce_query, total_bounce_previous: previous_metric.bounce_query, total_sum: metrics.total_query, total_previous: previous_metric.total_query, period: period, period_string: period_string
  end


  private def require_domain
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    @domain = DomainQuery.find(ids.first)
    raise Lucky::RouteNotFoundError.new(context) if @domain.nil?
    if DomainPolicy.show_share?(domain, current_user)
      continue
    else
      raise Lucky::RouteNotFoundError.new(context)
    end
  end

  private def domain : Domain
    @domain.not_nil!
  end

  private def goal : Goal?
    return nil if goal_id == 0
    GoalQuery.find(goal_id)
  end

  private def metrics : Metrics
    Metrics.new(domain, period, goal, site_path, source_name, medium_name)
  end
end
