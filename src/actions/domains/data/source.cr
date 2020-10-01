class Domains::Data::Source < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/sources" do
    html SourcePage, domain: domain, referrers: get_referrers, from: real_from, to: real_to
  end

  def get_referrers
    metrics.get_sources
  end
end
