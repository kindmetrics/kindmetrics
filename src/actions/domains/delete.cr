class Domains::Delete < BrowserAction
  route do
    DomainQuery.new.user_id(current_user.id).find(domain_id).delete
    flash.success = "Deleted the record"
    redirect Index
  end
end
