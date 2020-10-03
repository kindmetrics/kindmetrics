module ApiTrialCheck
  include SubscriptionCheck

  macro included
    before check_trial
  end

  def check_trial
    return continue if current_user.trial_ends_at > Time.utc
    return continue if current_user.admin?
    return continue unless subscription_user_check

    raise LuckyCan::ForbiddenError.new(context)
  end
end
