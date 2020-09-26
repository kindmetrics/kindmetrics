class Api::Domains::Show < ApiDomainBaseAction
  get "/api/domains/:domain_id" do
    json DomainStatsSerializer.new(domain, metrics)
  end
end
