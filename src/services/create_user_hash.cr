require "crypto/bcrypt"
class UserHash
  def self.create(address, ip_address, browser, browser_version) : String
    OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, "kindmetrics", [address, ip_address, browser, browser_version].join("/"))
  end

  def self.get_browser(user_agent)
    response = DeviceDetector::Detector.new(user_agent).call
    [response.browser_name, response.browser_version]
  end
end
