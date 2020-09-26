class Api::Domains::Data::Sources < ApiDomainBaseAction
  get "/api/domains/:domain_id/sources" do
    json Domain::SourceSerializer.new(domain, metrics)
  end
end
