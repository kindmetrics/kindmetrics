class Events::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken
  post "/api/track" do
    address = params.get?(:domain).to_s
    return error unless address.present?

    domain = DomainQuery.new.address(address).first
    return error if domain.nil?

    remote_ip = request.headers["X-Forwarded-For"]? || "92.35.68.246"
    user_agent = params.get?(:user_agent).to_s
    browser = UserHash.get_browser(user_agent) if user_agent.present?
    user_id = UserHash.create(address, remote_ip, browser.try { |b| b.browser_name } || "", browser.try { |b| b.browser_version } || "").to_s
    referrer = URI.parse params.get?(:referrer).try { |r| r.to_s } || ""
    url = URI.parse params.get?(:url).try { |r| r.to_s } || ""

    country = IPCountry.country.not_nil!.lookup_cc(remote_ip)

    handle_event(address, user_agent, browser, user_id, referrer, url, params, country, domain)

    head status: 200
  end

  def handle_event(address, user_agent, browser, user_id, referrer, url, params, country, domain)
    unless EventHandler.is_current_session?(user_id)
      EventHandler.create_session(user_agent: user_agent, referrer: referrer.to_s, referrer_domain: referrer.host, url: url.to_s, path: url.path, source: params.get?(:source).to_s, device: browser.try { |b| b.device_type }, browser_name: browser.try { |b| b.browser_name }, browser_version: browser.try { |b| b.browser_version }, operative_system: browser.try { |b| b.os_name }, domain_id: domain.id, user_id: user_id, is_bounce: false)
    end
    EventHandler.add_event(user_id, name: "pageview", user_agent: user_agent, referrer: referrer.to_s, referrer_domain: referrer.host, url: url.to_s, path: url.path, source: params.get?(:source).to_s, device: browser.try { |b| b.device_type }, browser_name: browser.try { |b| b.browser_name }, browser_version: browser.try { |b| b.browser_version }, operative_system: browser.try { |b| b.os_name }, domain_id: domain.id)
  end

  def error
    head status: 404
  end

  def render(error : Avram::RecordNotFoundError)
    head status: 404
  end
end
