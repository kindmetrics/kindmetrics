class Share::Show < BrowserAction
  include Auth::AllowGuests
  include DomainMetrics
  include Hashid
  include Period

  param period : String = "7d"
  param goal_id : Int64 = 0_i64
  param site_path : String = ""

  get "/share/:share_id" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)

    html Domains::ShowPage, domain: domain, goal: goal, site_path: site_path, share_page: true, total_unique: unique_query(domain, goal, site_path), total_unique_previous: unique_query_previous(domain, goal, site_path), total_bounce: bounce_query(domain, goal, site_path), total_bounce_previous: bounce_query_previous(domain, goal, site_path), total_sum: total_query(domain, goal, site_path), total_previous: total_query_previous(domain, goal, site_path), period: period, period_string: period_string
  end

  private def goal : Goal?
    return nil if goal_id == 0
    GoalQuery.find(goal_id)
  end
end
