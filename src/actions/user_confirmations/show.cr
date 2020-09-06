class UserConfirmations::Show < BrowserAction
  include Auth::AllowGuests
  get "/user_confirmations/:token" do
    user = UserQuery.new.from_confirmed_token(token).first?

    if user && user.confirmed?
      flash.keep
      flash.info = "You've already confirmed, please sign in."
      redirect to: SignIns::New
    elsif user && !user.confirmed?
      SaveUser.update(user, confirmed_at: Time.utc) do |operation, saving_user|
        if operation.saved?
          flash.keep
          flash.success = "You have been confirmed"
          redirect to: SignIns::New
        else
          flash.failure = "It looks like the form is not valid"
          html ConfirmPage, user: user
        end
      end
    else
      flash.keep
      flash.failure = "This confirmation does not exist or is expired"
      redirect to: SignIns::New
    end
  end
end
