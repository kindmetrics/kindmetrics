class Users::Plans::Cancelled < BrowserAction
  get "/me/plans/cancelled" do
    flash.keep
    flash.info = "Subscription got cancelled. It can take 1-2 minutes for the data below to be updated."
    redirect to: Users::Billing
  end
end
