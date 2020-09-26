module Api::Auth::Helpers
  def current_user? : User?
    auth_token.try do |value|
      user_from_auth_token(value)
    end
  end

  private def auth_token : String?
    bearer_token || token_param
  end

  private def bearer_token : String?
    context.request.headers["Authorization"]?
      .try(&.gsub("Bearer", ""))
      .try(&.strip)
  end

  private def token_param : String?
    params.get?(:token)
  end

  private def user_from_auth_token(token : String) : User?
    token = ApiTokenQuery.new.token(token).first?
    return nil if token.nil?
    token.not_nil!.user!
  end
end
