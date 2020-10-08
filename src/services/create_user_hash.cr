require "crypto/bcrypt"

class UserHash
  def self.create(address : String, ip_address : String, user_agent : String) : String
    time_string = Time.utc.to_s("%Y-%m-%d %p")
    OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, Lucky::Server.settings.secret_key_base, [address, ip_address, user_agent, time_string].join("/"))
  end

  def self.get_browser(user_agent)
    DeviceDetector::Detector.new(user_agent).call
  end
end
