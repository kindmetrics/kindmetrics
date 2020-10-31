class Domains::Countries::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/countries" do
    domains = DomainQuery.new.user_id(current_user.id)
    countries = metrics.get_countries(0)
    languages = metrics.get_languages(0)
    html IndexPage, domain: domain, from: real_from, to: real_to, period: period, domains: domains, countries: countries, languages: languages
  end
end
