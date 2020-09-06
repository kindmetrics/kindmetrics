class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  route do
    RequestPasswordReset.new(params).submit do |operation, user|
      if user
        PasswordResetRequestEmail.new(user).deliver
        flash.keep
        flash.success = "You should receive an email on how to reset your password shortly"
        redirect to: SignIns::New
      else
        html NewPage, operation: operation
      end
    end
  end
end
