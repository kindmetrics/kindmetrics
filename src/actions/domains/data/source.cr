class Domains::Data::Source < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/sources" do
    html SourcePage, domain: domain, referrers: get_referrers, from: string_to_date(from), to: string_to_date(to)
  end

  def get_referrers
    metrics.get_sources
  end
end
