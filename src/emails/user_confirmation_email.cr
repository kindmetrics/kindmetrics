class UserConfirmationEmail < BaseEmail
  to @user.email
  subject "Confirm your email"
  templates text, html

  def initialize(@user : User)
  end

end
