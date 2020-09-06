module SubscriptionCheck
  def subscription_time?(subscription : Subscription) : Bool
    subscription.cancelled? && subscription.next_bill_at < Time.utc
  end

  def subscription_user_check : Bool
    return true if current_user.not_nil!.admin?
    return false if current_user.not_nil!.subscription!.nil?
    return false if subscription_time?(current_user.not_nil!.subscription!.not_nil!)
    true
  end
end
