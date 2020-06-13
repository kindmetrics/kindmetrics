class Users::Delete < BrowserAction
  delete "/me" do
    current_user.delete
    sign_out
    flash.info = "You and all domains and data connected to you have been removed"
    redirect to: SignIns::New
  end
end
