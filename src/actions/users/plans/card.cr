class Users::Plans::Card < BrowserAction
  get "/me/plans/card" do
    flash.keep
    flash.success = "Your card got updated."
    redirect to: Users::Billing
  end
end
