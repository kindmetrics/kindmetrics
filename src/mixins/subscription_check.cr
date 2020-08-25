module SubscriptionCheck
  def subscription_time?(subscription : Subscription) : Bool
    subscription.cancelled? && subscription.next_bill_at < Time.utc
  end
end
