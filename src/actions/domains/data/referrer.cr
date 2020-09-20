class Domains::Data::Referrer < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/referrers" do
    html ReferrerPage, domain: domain, referrers: get_source_referrers, from: string_to_date(from), to: string_to_date(to)
  end

  def get_source_referrers
    metrics.get_referrers
  end
end
