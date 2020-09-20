class Domains::Countries::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/countries" do
    domains = DomainQuery.new.user_id(current_user.id)
    countries = metrics.get_countries
    html IndexPage, domain: domain, from: string_to_date(from), to: string_to_date(to), domains: domains, countries: countries
  end
end
