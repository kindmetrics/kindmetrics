class Share::Countries::Index < BrowserAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  param from : String = time_to_string(Time.utc - 7.days)
  param to : String = time_to_string(Time.utc)

  get "/share/:share_id/countries" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    metrics = Metrics.new(domain, string_to_date(from), string_to_date(to), nil, "", "", "")
    countries = metrics.get_countries
    html Domains::Countries::IndexPage, domain: domain, from: string_to_date(from), to: string_to_date(to), share_page: true, countries: countries
  end
end
