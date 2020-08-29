class Users::Plans < BrowserAction
  get "/plans" do
    UserPolicy.update_forbidden?(current_user, current_user, context)
    subscription = SubscriptionQuery.new.user_id(current_user.id).first?
    html PlansPage,
      operation: SaveUser.new(current_user), subscription: subscription
  end
end
