class UserQuery < User::BaseQuery
  def from_confirmed_token(token_value : String)
    confirmed_token(token_value)
  end
end
