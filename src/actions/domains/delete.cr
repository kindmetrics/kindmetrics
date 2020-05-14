class Domains::Delete < BrowserAction
  route do
    DomainQuery.find(domain_id).delete
    flash.success = "Deleted the record"
    redirect Index
  end
end
