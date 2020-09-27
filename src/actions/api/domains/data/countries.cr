class Api::Domains::Data::Countries < ApiDomainBaseAction
  get "/api/domains/:domain_id/countries" do
    json Domain::CountrySerializer.new(metrics)
  end
end
