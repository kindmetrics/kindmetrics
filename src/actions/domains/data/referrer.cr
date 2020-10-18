class Domains::Data::Referrer < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/referrers" do
    html ReferrerPage, domain: domain, referrers: get_source_referrers, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end

  def get_source_referrers
    metrics.get_referrers
  end
end
