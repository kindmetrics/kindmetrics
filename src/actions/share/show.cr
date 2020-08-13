class Share::Show < BrowserAction
  include Auth::AllowGuests
  include DomainMetrics
  include Hashid
  include Period

  param period : String = "7d"
  param goal_id : Int64?

  get "/share/:share_id" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)

    html Domains::ShowPage, domain: domain, share_page: true, total_unique: unique_query(domain), total_unique_previous: unique_query_previous(domain), total_bounce: bounce_query(domain), total_bounce_previous: bounce_query_previous(domain), total_sum: total_query(domain), total_previous: total_query_previous(domain), period: period, period_string: period_string
  end
end
