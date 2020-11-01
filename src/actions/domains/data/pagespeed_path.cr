class Domains::Data::PagespeedPath < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/pagespeeds/path" do
    data = parse_response
    html PagespeedPathPage, domain: domain, paths: parse_response, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end

  def parse_response
    metrics.get_pagespeed_path(0)
  end
end
