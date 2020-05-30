class Domains::Countries::Index < DomainBaseAction
  get "/domains/:domain_id/countries" do
    html IndexPage, domain: domain, period: period
  end
end
