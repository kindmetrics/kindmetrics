class AppClient < Lucky::BaseHTTPClient
  def initialize
    super
    headers("Content-Type": "application/json")
  end

  def self.auth(token : ApiToken)
    new.headers("Authorization": token.token)
  end
end
