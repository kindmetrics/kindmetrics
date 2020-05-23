class Domains::Data::Country < BrowserAction
  param period : String = "7d"

  get "/domains/:domain_id/data/countries" do
    domain = DomainQuery.find(domain_id)
    html CountriesPage, domain: domain, countries: get_countries(domain)
  end

  def get_countries(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_countries
  end
end
