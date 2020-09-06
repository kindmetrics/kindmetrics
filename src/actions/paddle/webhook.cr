class Paddle::Webhook < ApiAction
  include PaddleVerify
  include Api::Auth::SkipRequireAuthToken

  post "/paddle/webhook" do
    email = params.get?(:email)
    return error if email.nil?
    return error if user.nil?
    return error unless verify_sign(params.to_h)

    kind = params.get?(:alert_name)

    case kind
    when "subscription_created"
      create_subscription
    when "subscription_updated"
      update_subscription
    when "subscription_cancelled"
      cancel_subscription
    else
      return head status: 404
    end

    head status: 200
  end

  def create_subscription
    next_bill_at = Time.parse_utc(params.get?(:next_bill_date) || "", "%F")

    checkout_id = params.get(:checkout_id)
    plan_id = params.get(:subscription_plan_id)
    subscription_id = params.get(:subscription_id)
    update_url = params.get(:update_url)
    cancel_url = params.get(:cancel_url)

    subscription = user.not_nil!.subscription

    if subscription.nil?
      SaveSubscription.create!(user_id: user.not_nil!.id, cancelled: false, cancel_url: cancel_url, update_url: update_url, subscription_id: subscription_id, checkout_id: checkout_id, next_bill_at: next_bill_at, plan_id: plan_id)
    else
      SaveSubscription.update!(subscription, cancel_url: cancel_url, update_url: update_url, subscription_id: subscription_id, checkout_id: checkout_id, next_bill_at: next_bill_at, plan_id: plan_id, cancelled: false)
    end
  end

  def update_subscription
    return if user.nil?
    checkout_id = params.get(:checkout_id)
    plan_id = params.get(:subscription_plan_id)
    subscription_id = params.get(:subscription_id)
    update_url = params.get(:update_url)
    cancel_url = params.get(:cancel_url)
    next_bill_at = Time.parse_utc(params.get?(:next_bill_date) || "", "%F")

    subscription = user.not_nil!.subscription
    return if subscription.nil?

    SaveSubscription.update!(subscription, subscription_id: subscription_id, checkout_id: checkout_id, cancel_url: cancel_url, update_url: update_url, next_bill_at: next_bill_at, plan_id: plan_id)
  end

  def cancel_subscription
    return if user.nil?
    subscription = user.not_nil!.subscription
    return if subscription.nil?

    SaveSubscription.update!(subscription.not_nil!, cancelled: true)
  end

  def user
    user_id = params.get?(:passthrough)
    return nil if user_id.nil?
    UserQuery.new.preload_subscription.find(user_id.not_nil!.to_i64)
  end

  def error
    head status: 422
  end
end
