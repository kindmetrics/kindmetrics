class Users::Plans::Success < BrowserAction

  get "/me/plans/success" do
    html SuccessPage
  end
end
