class EventHandler
  def self.handle_event(address, remote_ip, user_agent, referrer, url, params, domain)
    return if url.host.nil?
    hostname = remove_www(url.host.not_nil!)

    AddClickhouse.clean_database

    if Lucky::Env.production?
      return unless hostname.ends_with?(domain.address)
    end

    name = params.get?(:name)

    return if name.nil?

    if name != "pageview"
      return if GoalQuery.new.domain_id(domain.id).name(name).size == 0
    end

    country = if !remote_ip.nil? && !remote_ip.not_nil!.includes?("127.0.0.1")
                IPCOUNTRY.lookup_cc(remote_ip)
              else
                nil
              end

    browser = UserHash.get_browser(user_agent) if user_agent.present?
    user_id = UserHash.create(url.host || address, remote_ip || "", user_agent).to_s

    if user_agent.present? && !browser.nil?
      return if browser.not_nil!.bot?
    end

    page_load = params.get?(:page_load).try(&.to_i) || 0
    language = params.get?(:language).try(&.split("-").first)

    temp_source = params.get?(:source)
    temp_medium = params.get?(:medium)
    source = if !temp_source.nil? && !temp_source.empty?
               temp_source
             else
               referer_source(referrer)
             end
    medium = if !temp_medium.nil? && !temp_medium.empty?
               temp_medium
             else
               referer_medium(referrer)
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

    if !is_current_session?(user_id)
      create_session(
        **browser_data,
        is_bounce: 0,
        length: nil,
        name: name,
        device: device,
        referrer: referrer.to_s,
        referrer_domain: referrer.host,
        country: country,
        url: url.to_s,
        path: url.path,
        page_load: page_load,
        language: language,
        referrer_medium: medium,
        referrer_source: source,
        domain_id: domain.id,
        user_id: user_id,
      )
    else
      add_event(
        user_id,
        **browser_data,
        device: device,
        name: name,
        referrer: referrer.to_s,
        country: country,
        referrer_domain: referrer.host,
        url: url.to_s,
        path: url.path,
        page_load: page_load,
        language: language,
        referrer_medium: medium,
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

  def self.add_event(user_id : String, name, referrer, url, referrer_source, referrer_medium, path, device, operative_system, referrer_domain, browser_name, page_load, language : String?, country, domain_id)
    session = get_session(user_id)
    if session
      AddClickhouse.event_insert(user_id, name, referrer, url, referrer_source, referrer_medium, path, device, operative_system, referrer_domain, browser_name, country, page_load, language, domain_id, session_id: session.not_nil!.id)
    else
      puts "session not found?"
    end
  end

  def self.create_session(user_id : String, length : Int64?, name : String, is_bounce : Int32, referrer : String?, url : String?, referrer_source : String?, referrer_medium : String?, path : String?, device : String?, page_load : Int32, language : String?, operative_system : String?, referrer_domain : String?, browser_name : String?, country : String?, domain_id : Int64, created_at : Time = Time.utc, mark : Int8 = 0)
    id = Random.new.rand(0_i64..Int64::MAX)
    AddClickhouse.session_insert(id, user_id, name, length, is_bounce, referrer, url, referrer_source, referrer_medium, path, device, operative_system, referrer_domain, browser_name, country, page_load, language, domain_id, created_at.to_utc, mark: mark)
    AddClickhouse.event_insert(user_id, name, referrer, url, referrer_source, referrer_medium, path, device, operative_system, referrer_domain, browser_name, country, page_load, language, domain_id, session_id: id, created_at: created_at.to_utc)
  end

  def self.referer_source(referrer : URI) : String?
    response = referer_parser(referrer)
    response[:source]? || use_host(referrer)
  end

  def self.referer_medium(referrer : URI) : String?
    response = referer_parser(referrer)
    response[:medium]?
  end

  def self.referer_parser(referrer : URI)
    REFERERPARSER.parse(referrer.to_s)
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
    if widthi < 576
      "Mobile"
    elsif widthi < 992
      "Tablet"
    elsif widthi < 1440
      "Laptop"
    elsif widthi >= 1440
      "Desktop"
    else
      "Unknown"
    end
  end

  private def self.get_session(user_id : String) : Session?
    AddClickhouse.get_session(user_id)
  rescue Exception
    nil
  end
end
