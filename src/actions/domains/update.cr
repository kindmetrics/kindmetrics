class Domains::Update < BrowserAction
  route do
    domain = DomainQuery.find(domain_id)
    SaveDomain.update(domain, params) do |operation, domain|
      if operation.saved?
        flash.success = "The record has been updated"
        redirect Show.with(domain.id)
      else
        flash.failure = "It looks like the form is not valid"
        html EditPage, operation: operation, domain: domain
      end
    end
  end
end
