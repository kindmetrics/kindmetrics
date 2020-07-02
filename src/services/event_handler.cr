class EventHandler
  def self.handle_event(address, remote_ip, user_agent, referrer, url, params, domain)
    return if url.host.nil?
    hostname = remove_www(url.host.not_nil!)

    if Lucky::Env.production?
      return unless hostname.ends_with?(domain.address)
    end

    country = IPCOUNTRY.lookup_cc(remote_ip)

    browser = UserHash.get_browser(user_agent) if user_agent.present?
    user_id = UserHash.create(address, remote_ip, user_agent).to_s

    if user_agent.present? && !browser.nil?
      return if browser.not_nil!.bot?
    end

    temp_source = params.get?(:source)
    source = if !temp_source.nil? && !temp_source.empty?
               temp_source
             else
               parse_referer_data(referrer)
             end

    browser_data = {
      browser_name:     browser.try { |b| b.browser_name },
      operative_system: browser.try { |b| b.os_name },
    }
    screen_device = screen_width(params.get?(:screen_width))
    browser_device = browser_device(browser)
    device = if screen_device != "Unknown"
               screen_device
             elsif !browser_device.nil?
               browser_device
             else
               "Unknown"
             end

    unless is_current_session?(user_id)
      create_session(
        **browser_data,
        is_bounce: 0,
        length: nil,
        name: "pageview",
        device: device,
        referrer: referrer.to_s,
        referrer_domain: referrer.host,
        country: country,
        url: url.to_s,
        path: url.path,
        referrer_source: source,
        domain_id: domain.id,
        user_id: user_id,
      )
    else
      add_event(
        user_id,
        **browser_data,
        device: device,
        name: "pageview",
        referrer: referrer.to_s,
        country: country,
        referrer_domain: referrer.host,
        url: url.to_s,
        path: url.path,
        referrer_source: source,
        domain_id: domain.id
      )
    end
  end

  def self.is_current_session?(user_id : String)
    session = get_session(user_id)
    return false unless session
    return false unless session.length.nil?
    events = AddClickhouse.get_last_event(session)
    return false if events.size == 0
    return events.first.created_at > SESSION_TIMEOUT.ago
  end

  def self.add_event(user_id : String, name, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id)
    session = get_session(user_id)
    if session
      AddClickhouse.event_insert(user_id, name, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id, session_id: session.not_nil!.id)
    else
      puts "session not found?"
    end
  end

  def self.create_session(user_id : String, length : Int64?, name : String, is_bounce : Int32, referrer : String?, url : String?, referrer_source : String?, path : String?, device : String?, operative_system : String?, referrer_domain : String?, browser_name : String?, country : String?, domain_id : Int64)
    AddClickhouse.session_insert(user_id, length, is_bounce, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id)
    session = get_session(user_id)
    AddClickhouse.event_insert(user_id, name, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id, session_id: session.not_nil!.id)
  end

  def self.parse_referer_data(referrer : URI)
    response = REFERERPARSER.parse(referrer.to_s)
    response[:source]? || use_host(referrer)
  end

  private def self.use_host(referrer)
    if ["http", "https"].includes?(referrer.scheme) && !referrer.host.nil?
      remove_www(referrer.host.not_nil!)
    end
  end

  private def self.remove_www(uri : String)
    uri.sub(/^www./i, "")
  end

  private def self.browser_device(browser)
    if !browser.nil? && browser.mobile_device?
      "Mobile"
    else
      nil
    end
  end

  private def self.screen_width(width : String?) : String
    return "Unknown" if width.nil?
    return "Unknown" if width.empty?
    widthi = width.not_nil!.to_i
    if widthi.to_i < 576
      return "Mobile"
    elsif widthi.to_i < 992
      return "Tablet"
    elsif widthi.to_i < 1440
      return "Laptop"
    elsif widthi.to_i >= 1440
      return "Desktop"
    else
      return "Unknown"
    end
  end

  private def self.get_session(user_id : String) : ClickSession?
    AddClickhouse.get_session(user_id)
  rescue Exception
    nil
  end
end
