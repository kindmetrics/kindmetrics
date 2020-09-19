class TrialReminder
  extend SubscriptionCheck

  def self.send_reminders
    seven_days_reminder
    three_days_reminder
    trial_ended
  end

  def self.seven_days_reminder
    users = UserQuery.new.confirmed_at.is_not_nil.trial_ends_at.lte(Time.utc.at_end_of_day + 7.days).trial_ends_at.gte(Time.utc.at_beginning_of_day + 7.days)

    users.each do |u|
      next if check_subscription(u)
      TrialHalfReminderEmail.new(u).deliver
    end
  end

  def self.three_days_reminder
    users = UserQuery.new.confirmed_at.is_not_nil.trial_ends_at.lte(Time.utc.at_end_of_day + 3.days).trial_ends_at.gte(Time.utc.at_beginning_of_day + 3.days)

    users.each do |u|
      next if check_subscription(u)
      TrialThreeDaysReminderEmail.new(u).deliver
    end
  end

  def self.trial_ended
    users = UserQuery.new.confirmed_at.is_not_nil.trial_ends_at.lte(Time.utc.at_end_of_day).trial_ends_at.gte(Time.utc.at_beginning_of_day)

    users.each do |u|
      next if check_subscription(u)
      TrialEndReminderEmail.new(u).deliver
    end
  end

  private def self.check_subscription(user)
    return true if user.admin?
    subscription = user.subscription!
    return false if subscription.nil?
    return false if subscription_time?(subscription)
    return true
  end

end
