class Api::Domains::Data::Pages < ApiDomainBaseAction
  get "/api/domains/:domain_id/pages" do
    json Domain::PageSerializer.new(metrics)
  end
end
