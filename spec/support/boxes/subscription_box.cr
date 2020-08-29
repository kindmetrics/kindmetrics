class SubscriptionBox < Avram::Box
  def initialize
    subscription_id sequence("sub_id")
    next_bill_at Time.utc + 6.days
    checkout_id sequence("checkout_id")
    plan_id sequence("plan_id")
    cancelled false
    user_id UserBox.create.id
  end
end
