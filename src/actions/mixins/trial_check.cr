module TrialCheck
  include SubscriptionCheck

  macro included
    before check_trial
  end

  def check_trial
    return continue if current_user.trial_ends_at > Time.utc
    return continue if current_user.admin?
    return continue if subscription_user_check

    flash.keep
    flash.info = "Your trial has passed. You would need to subscribe to continue using Kindmetrics"

    redirect to: Users::Billing
  end
end
