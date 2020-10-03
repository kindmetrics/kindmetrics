class Api::Domains::Data::Referrers < ApiDomainBaseAction
  get "/api/domains/:domain_id/Referrers" do
    json Domain::ReferrerSerializer.new(metrics)
  end
end
