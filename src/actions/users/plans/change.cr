class Users::Plans::Update < BrowserAction

  param plan_id : Int64

  get "/me/plans/update" do
    return head 404 if current_user.subscription!.nil?

    subscription = current_user.subscription!.not_nil!

    io = IO::Memory.new
    builder = HTTP::Params::Builder.new(io)
    builder.add("vendor_id", KindEnv.env("PADDLE_VENDOR"))
    builder.add("vendor_auth_code", KindEnv.env("PADDLE_VENDOR_AUTH"))
    builder.add("subscription_id", subscription.subscription_id)
    builder.add("plan_id", plan_id.to_s)

    response = HTTP::Client.post("https://vendors.paddle.com/api/2.0/subscription/users/update", form: io.to_s)

    json_response = JSON.parse(response.body)
    pp! json_response
    if json_response["success"]
      SaveSubscription.update!(subscription, plan_id: plan_id.to_s, cancelled: false)
    end

    redirect to: Users::Billing
  end
end
