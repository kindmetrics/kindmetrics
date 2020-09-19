class Domains::Data::Source < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/sources" do
    html SourcePage, domain: domain, referrers: get_referrers, period: period
  end

  def get_referrers
    metrics.get_sources
  end
end
