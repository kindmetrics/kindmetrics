module TrialCheck
  include SubscriptionCheck

  macro included
    before check_trial
  end

  def check_trial
    return continue if current_user.trial_ends_at > Time.utc

    subscription = current_user.subscription!

    return continue unless subscription.nil? || subscription_time?(subscription)

    redirect to: Users::Billing
  end
end
