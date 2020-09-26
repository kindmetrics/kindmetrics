class Users::ApiTokens::Index < BrowserAction
  get "/me/tokens" do
    UserPolicy.update_forbidden?(current_user, current_user, context)
    html IndexPage, tokens: ApiTokenQuery.new.user_id(current_user.id)
  end
end
