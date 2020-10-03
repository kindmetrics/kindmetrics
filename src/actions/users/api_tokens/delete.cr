class Users::ApiTokens::Delete < BrowserAction
  delete "/me/tokens/:token_id" do
    UserPolicy.update_forbidden?(current_user, current_user, context)
    token = ApiTokenQuery.find(token_id)
    token.delete
    flash.keep
    flash.success = "Token Deleted"
    redirect to: Users::ApiTokens::Index
  end
end
