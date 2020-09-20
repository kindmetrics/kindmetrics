class Share::Referrer::Index < BrowserAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  param from : String = time_to_string(Time.utc - 7.days)
  param to : String = time_to_string(Time.utc)

  get "/share/:share_id/referrers" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    html Domains::Referrer::IndexPage, referrers: get_referrals(domain), mediums: get_mediums(domain), domain: domain, from: string_to_date(from), to: string_to_date(to), share_page: true
  end

  def get_referrals(domain)
    metrics = Metrics.new(domain, string_to_date(from), string_to_date(to), nil, "", "", "")
    metrics.get_all_referrers
  end

  def get_mediums(domain)
    metrics = Metrics.new(domain, string_to_date(from), string_to_date(to), nil, "", "", "")
    metrics.get_all_medium_referrers
  end
end
