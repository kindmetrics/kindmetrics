class Domains::Data::Country < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/countries" do
    html CountriesPage, domain: domain, countries: get_countries, from: real_from, to: real_to
  end

  def get_countries
    metrics.get_countries
  end
end
