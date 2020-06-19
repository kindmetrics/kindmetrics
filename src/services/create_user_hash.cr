require "crypto/bcrypt"

class UserHash
  def self.temp_create(address, ip_address, user_agent) : String
    OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, Lucky::Server.settings.secret_key_base, [address, ip_address, user_agent].join("/"))
  end

  def self.create(address, ip_address, user_agent, created_at) : String
    OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, Lucky::Server.settings.secret_key_base, [address, ip_address, user_agent, created_at].join("/"))
  end

  def self.get_browser(user_agent)
    DeviceDetector::Detector.new(user_agent).call
  end
end
