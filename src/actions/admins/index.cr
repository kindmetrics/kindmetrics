class Admins::Index < BrowserAction
  route do
    UserPolicy.see_admin_not_found?(current_user, context)
    html IndexPage, users: UserQuery.new, confirmed_users: UserQuery.new.confirmed_at.is_not_nil, domains: DomainQuery.new
  end
end
