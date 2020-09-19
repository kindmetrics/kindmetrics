class TrialEndReminderEmail < BaseEmail
  to Carbon::Address.new(@user.email)
  subject "Your Kindmetrics trial has ended"
  templates text

  def initialize(@user : User)

  end
end
