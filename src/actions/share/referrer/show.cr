class Share::Referrer::Show < DomainShareBaseAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  get "/share/:share_id/referrers/:source" do
    html Domains::Referrer::ShowPage, domain: domain, total: get_total, events: get_referrals, source: parse_source, from: real_from, to: real_to, period: period, share_page: true
  end

  def get_referrals
    metrics.get_referrers
  end

  def get_total
    metrics.get_source_referrers_total
  end

  def parse_source
    URI.decode(source).sub("+", " ")
  end
end
