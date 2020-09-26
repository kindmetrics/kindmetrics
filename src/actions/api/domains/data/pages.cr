class Api::Domains::Data::Pages < ApiDomainBaseAction
  get "/api/domains/:domain_id/pages" do
    json Domain::PageSerializer.new(domain, metrics)
  end
end
