class Share::Referrer::Show < BrowserAction
  include Auth::AllowGuests
  include Hashid

  param period : String = "7d"

  get "/share/:share_id/referrers/:source" do
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?
    domain = DomainQuery.find(ids.first)
    DomainPolicy.show_share_not_found?(domain, current_user, context)
    html Domains::Referrer::ShowPage, domain: domain, total: get_total(domain), events: get_referrals(domain), source: parse_source, period: period, share_page: true
  end

  def get_referrals(domain)
    metrics = Metrics.new(domain, period, nil, "", source, "")
    metrics.get_source_referrers
  end

  def get_total(domain)
    metrics = Metrics.new(domain, period, nil, "", source, "")
    metrics.get_source_referrers_total
  end

  def parse_source
    URI.decode(source).sub("+", " ")
  end
end
