class SaveApiToken < ApiToken::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  # permit_columns column_1, column_2

  before_save do
    token.value = Random::Secure.urlsafe_base64(32)
  end

  def create_token
    time_string = Time.utc.to_s
    OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, Lucky::Server.settings.secret_key_base, [user_id.value, time_string].join("/"))
  end
end
