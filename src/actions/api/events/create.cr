class Events::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken
  post "/api/track" do
    address = params.get(:domain).to_s
    return error unless address.present?

    domain = DomainQuery.new.address(address).first
    return error unless domain.present?

    remote_ip = request.headers["X-Forwarded-For"]? || "localhost"
    puts request.headers.to_s
    user_agent = params.get(:user_agent).to_s
    browser = UserHash.get_browser(user_agent) if user_agent.present?
    user_id = UserHash.create(address, remote_ip, browser.try { |b| b.browser_name } || "", browser.try { |b| b.browser_version } || "").to_s
    referrer = URI.parse params.get(:referrer).try { |r| r.to_s } || ""
    url = URI.parse params.get(:url).try { |r| r.to_s } || ""

    ip2country = IPCountry.country.not_nil!
    ip_address = IPGeolocation::IPAddress.new(remote_ip)
    address_as_int = ip_address.to_u32
    if address_as_int
      country = ip2country.find(address_as_int)
    else
      country = nil
    end
    puts country
    Log.debug { {country: country} }

    SaveEvent.create(name: params.get(:name).to_s, user_agent: user_agent, referrer: referrer.to_s, referrer_domain: referrer.host, url: url.to_s, path: url.path, source: params.get(:source).to_s, device: browser.try { |b| b.device_type }, browser_name: browser.try { |b| b.browser_name }, browser_version: browser.try { |b| b.browser_version }, operative_system: browser.try { |b| b.os_name }, domain_id: domain.id, user_id: user_id) do |operation, event|
      if event
        Log.debug { "Yay, saved!" }
      else
        Log.debug { "Not saved, error" }
      end
    end
    head status: 200
  end

  def error
    head status: 404
  end

  def render(error : Avram::RecordNotFoundError)
    head status: 404
  end
end
