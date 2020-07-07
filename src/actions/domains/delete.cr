class Domains::Delete < BrowserAction
  route do
    domain = DomainQuery.new.preload_user.find(domain_id)
    if DomainPolicy.delete?(domain, current_user)
      current_domain_id = domain.user.current_domain!.try { |d| d.id }
      if current_domain_id == domain.id
        SaveUser.update!(domain.user, current_domain_id: nil)
      end
      temp_domain_id = domain.id
      domain.delete
      AddClickhouse.delete(temp_domain_id)
      flash.success = "Deleted the record"
    end
    redirect Home::Index
  end
end
