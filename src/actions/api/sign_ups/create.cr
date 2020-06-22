class Api::SignUps::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken

  route do
    user = SignUpUser.create!(params, admin: false)
    json({token: UserToken.generate(user)})
  end
end
