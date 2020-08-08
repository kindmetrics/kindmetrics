class Domains::Data::Referrer < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/referrer" do
    html ReferrerPage, domain: domain, referrers: get_referrers, period: period
  end

  def get_referrers
    metrics.get_referrers
  end
end
