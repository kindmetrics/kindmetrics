class ApiTokenQuery < ApiToken::BaseQuery
  def current_user
    user_id(current_user.id)
  end
end
