class Share::Referrer::Index < DomainShareBaseAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  get "/share/:share_id/referrers" do
    html Domains::Referrer::IndexPage, referrers: get_referrals, mediums: get_mediums, domain: domain, from: real_from, to: real_to, period: period, share_page: true
  end

  def get_referrals
    metrics.get_sources(0)
  end

  def get_mediums
    metrics.get_all_medium_referrers
  end
end
