class SignUps::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  post "/sign_up" do
    SignUpUser.create(params, admin: false) do |operation, user|
      if user
        flash.keep
        flash.info = "Sent an email for confirm"
        redirect to: SignIns::New
      else
        flash.info = "Couldn't sign you up"
        html NewPage, operation: operation
      end
    end
  end
end
