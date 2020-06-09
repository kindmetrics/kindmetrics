class UserConfirmationEmail < BaseEmail
  to Carbon::Address.new(@user.name.not_nil!, @user.email)
  subject "Confirm your email on Kindmetrics"
  templates text, html

  def initialize(@user : User)
  end
end
