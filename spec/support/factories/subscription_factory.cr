class SubscriptionFactory < Avram::Factory
  def initialize
    subscription_id sequence("sub_id")
    next_bill_at Time.utc + 6.days
    checkout_id sequence("checkout_id")
    plan_id sequence("plan_id")
    update_url sequence("update_url")
    cancel_url sequence("cancel_url")
    cancelled false
    user_id UserBox.create.id
  end
end
