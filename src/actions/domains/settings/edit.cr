class Domains::Edit < BrowserAction
  include Hashid
  get "/domins/:domain_id/settings" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    domains = DomainQuery.new.user_id(current_user.id)
    html EditPage,
      operation: UpdateDomain.new(domain, current_user: current_user),
      domain: domain,
      hashid: hashids.encode([domain.id]),
      domains: domains
  end
end
