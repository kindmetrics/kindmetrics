class Domains::Edit < BrowserAction
  route do
    domain = DomainQuery.find(domain_id)
    html EditPage,
      operation: SaveDomain.new(domain),
      domain: domain
  end
end
