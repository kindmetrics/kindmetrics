class Domains::Data::Country < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/countries" do
    html CountriesPage, domain: domain, countries: get_countries, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end

  def get_countries
    metrics.get_countries
  end
end
