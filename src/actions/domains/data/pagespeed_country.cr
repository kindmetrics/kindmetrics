class Domains::Data::PagespeedCountry < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/pagespeeds/countries" do
    data = parse_response
    html PagespeedCountryPage, domain: domain, countries: parse_response, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end

  def parse_response
    metrics.get_pagespeed_country(0)
  end
end
