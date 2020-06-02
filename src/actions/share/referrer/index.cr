class Share::Referrer::Index < BrowserAction
  include Auth::AllowGuests
  include Hashid

  param period : String = "7d"

  get "/share/:share_id/referrers" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    html Domains::Referrer::IndexPage, events: get_referrals(domain), domain: domain, period: period, share_page: true
  end

  def get_referrals(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_all_referrers
  end
end
