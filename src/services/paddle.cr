class Paddle
  BASE_URL = "https://vendors.paddle.com/api/2.0"

  def initialize(@subscription : Subscription)
    @site = Crest::Resource.new(BASE_URL)
  end

  def cancel
    res = @site.post(
      "/subscription/users_cancel",
      form: {vendor_id: ENV["PADDLE_VENDOR"]?.try(&.strip), vendor_auth_code: ENV["PADDLE_AUTH_CODE"]?.try(&.strip), subscription_id: @subscription.subscription_id.to_i},
      handle_errors: false
    ).success?
    @subscription.delete if res
  end

  def update(new_plan_id)
    @site.post(
      "/subscription/users/update",
      form: {vendor_id: ENV["PADDLE_VENDOR"]?.try(&.strip), vendor_auth_code: ENV["PADDLE_AUTH_CODE"]?.try(&.strip), subscription_id: @subscription.subscription_id.to_i, plan_id: new_plan_id},
      handle_errors: false
    ).success?
  end
end
