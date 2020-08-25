class Subscription < BaseModel
  table do
    column subscription_id : String
    column next_bill_at : Time
    column checkout_id : String
    column plan_id : String
    column cancelled : Bool
    belongs_to user : User
  end

  def price
    plan.try { |p| p["price"] }
  end

  def pageviews
    plan.try { |p| p["views"] }
  end

  def plan
    PLANS.find { |i| i["id"] == plan_id }
  end
end
