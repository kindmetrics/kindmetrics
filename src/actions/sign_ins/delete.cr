class SignIns::Delete < BrowserAction
  get "/sign_out" do
    sign_out
    flash.info = "You have been signed out"
    flash.keep
    redirect to: SignIns::New
  end
end
