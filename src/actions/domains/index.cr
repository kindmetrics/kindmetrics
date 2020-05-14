class Domains::Index < BrowserAction
  route do
    html IndexPage, domains: DomainQuery.new.user_id(current_user.id)
  end
end
