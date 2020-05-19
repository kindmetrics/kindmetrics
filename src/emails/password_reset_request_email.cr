class PasswordResetRequestEmail < BaseEmail
  Habitat.create { setting stubbed_token : String? }
  delegate stubbed_token, to: :settings

  def initialize(@user : User)
    @token = stubbed_token || Authentic.generate_password_reset_token(@user)
  end

  to @user
  subject "Reset your password"
  templates html, text
end
