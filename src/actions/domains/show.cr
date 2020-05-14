class Domains::Show < BrowserAction
  route do
    html ShowPage, domain: DomainQuery.find(domain_id)
  end
end
