class Api::Domains::Data::Current < ApiDomainBaseAction
  get "/api/domains/:domain_id/current" do
    json Domain::CurrentSerializer.new(metrics)
  end
end
