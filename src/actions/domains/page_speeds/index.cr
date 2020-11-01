class Domains::PageSpeeds::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/page_speeds" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, domain: domain, from: real_from, to: real_to, period: period, domains: domains
  end
end
