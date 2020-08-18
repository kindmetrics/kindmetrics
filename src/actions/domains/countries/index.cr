class Domains::Countries::Index < DomainBaseAction
  get "/domains/:domain_id/countries" do
    domains = DomainQuery.new.user_id(current_user.id)
    metrics = Metrics.new(domain, period)
    countries = metrics.get_countries
    html IndexPage, domain: domain, period: period, domains: domains, countries: countries
  end
end
