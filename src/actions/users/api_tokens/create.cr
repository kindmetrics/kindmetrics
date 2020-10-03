class Users::ApiTokens::Create < BrowserAction
  get "/me/tokens/create" do
    UserPolicy.update_forbidden?(current_user, current_user, context)
    SaveApiToken.create!(user_id: current_user.id)
    flash.keep
    flash.success = "Token Created"
    redirect to: Users::ApiTokens::Index
  end
end
