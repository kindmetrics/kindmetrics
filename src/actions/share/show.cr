class Share::Show < BrowserAction
  include Auth::AllowGuests
  include DomainMetrics
  include Hashid
  include Period

  param period : String = "7d"

  get "/share/:share_id" do
    ids = hashids.decode(share_id)
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)

    html ShowPage, domain: domain, total_unique: unique_query(domain), total_bounce: bounce_query(domain), total_sum: total_query(domain), period: period, period_string: period_string
  end
end
