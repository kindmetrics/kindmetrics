class Domains::Countries::Index < DomainBaseAction
  get "/domains/:domain_id/countries" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, domain: domain, period: period, domains: domains
  end
end
