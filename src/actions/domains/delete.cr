class Domains::Delete < BrowserAction
  route do
    domain = DomainQuery.find(domain_id)
    domain.delete if DomainPolicy.delete?(domain, current_user)
    flash.success = "Deleted the record"
    redirect Index
  end
end
