class Share::Referrer::Show < BrowserAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  param from : String = time_to_string(Time.utc - 7.days)
  param to : String = time_to_string(Time.utc)

  get "/share/:share_id/referrers/:source" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    html Domains::Referrer::ShowPage, domain: domain, total: get_total(domain), events: get_referrals(domain), source: parse_source, from: string_to_date(from), to: string_to_date(to), share_page: true
  end

  def get_referrals(domain)
    metrics = Metrics.new(domain, string_to_date(from), string_to_date(to), nil, "", source, "")
    metrics.get_referrers
  end

  def get_total(domain)
    metrics = Metrics.new(domain, string_to_date(from), string_to_date(to), nil, "", source, "")
    metrics.get_source_referrers_total
  end

  def parse_source
    URI.decode(source).sub("+", " ")
  end
end
