class Domains::Data::Countries < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/countries_map" do
    data = parse_response(domain)
    json CountriesSerializer.new(data)
  end

  def parse_response(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_countries_map
  end
end
