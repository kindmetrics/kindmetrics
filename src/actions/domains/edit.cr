class Domains::Edit < BrowserAction
  route do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    html EditPage,
      operation: SaveDomain.new(domain, current_user: current_user),
      domain: domain
  end
end
