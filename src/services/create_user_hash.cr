require "crypto/bcrypt"
class UserHash
  def self.create(address, ip_address, browser, browser_version)
    Crypto::Bcrypt.hash_secret([address, ip_address, browser, browser_version].join("/"))
  end

  def self.get_browser(user_agent)
    response = DeviceDetector::Detector.new(user_agent).call
    [response.browser_name, response.browser_version]
  end
end
