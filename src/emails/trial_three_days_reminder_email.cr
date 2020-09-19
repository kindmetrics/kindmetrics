class TrialThreeDaysReminderEmail < BaseEmail
  to Carbon::Address.new(@user.email)
  subject "Your trial expires in 3 days"
  templates text

  def initialize(@user : User)
  end
end
