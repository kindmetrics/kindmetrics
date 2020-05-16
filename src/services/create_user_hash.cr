require "crypto/bcrypt"
class UserHash
  def self.create(address, ip_address, browser, browser_version) : String
    Log.debug { {address: address, ip_address: ip_address, browser: browser, browser_version: browser_version} }
    OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, "kindmetrics", [address, ip_address, browser, browser_version].join("/"))
  end

  def self.get_browser(user_agent)
    DeviceDetector::Detector.new(user_agent).call
  end
end
