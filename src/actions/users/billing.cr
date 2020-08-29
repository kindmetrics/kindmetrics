class Users::Billing < BrowserAction
  get "/me/billing" do
    UserPolicy.update_forbidden?(current_user, current_user, context)
    subscription = SubscriptionQuery.new.user_id(current_user.id).first?
    events_count = AddClickhouse.all_events_count(current_user)
    html BillingPage,
      operation: SaveUser.new(current_user), subscription: subscription, events_count: events_count
  end
end
