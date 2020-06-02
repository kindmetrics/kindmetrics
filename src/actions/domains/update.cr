class Domains::Update < BrowserAction
  include Hashid
  route do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    SaveDomain.update(domain, params, current_user: current_user) do |operation, domain|
      if operation.saved?
        flash.success = "The record has been updated"
        redirect Show.with(domain.id)
      else
        flash.failure = "It looks like the form is not valid"
        html EditPage, operation: operation, domain: domain, hashid: hashids.encode([domain.id])
      end
    end
  end
end
