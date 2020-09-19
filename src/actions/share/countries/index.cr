class Share::Countries::Index < BrowserAction
  include Auth::AllowGuests
  include Hashid

  param period : String = "7d"

  get "/share/:share_id/countries" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    metrics = Metrics.new(domain, period, nil, "", "", "")
    countries = metrics.get_countries
    html Domains::Countries::IndexPage, domain: domain, period: period, share_page: true, countries: countries
  end
end
