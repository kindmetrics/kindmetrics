class TrialHalfReminderEmail < BaseEmail
  to Carbon::Address.new(@user.email)
  subject "Your trial expires next week"
  templates text

  def initialize(@user : User)
  end
end
