class Users::Edit < BrowserAction
  get "/me" do
    UserPolicy.update_forbidden?(current_user, current_user, context)
    html EditPage,
      operation: SaveUser.new(current_user)
  end
end
