class Api::Domains::Data::Sources < ApiDomainBaseAction
  get "/api/domains/:domain_id/sources" do
    json Domain::SourceSerializer.new(metrics)
  end
end
