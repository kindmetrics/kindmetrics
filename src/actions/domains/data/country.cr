class Domains::Data::Country < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/countries" do
    html CountriesPage, domain: domain, countries: get_countries(domain)
  end

  def get_countries(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_countries
  end
end
