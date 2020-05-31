class Domains::Countries::Index < DomainPublicBaseAction
  get "/domains/:domain_id/countries" do
    html IndexPage, domain: domain, period: period
  end
end
