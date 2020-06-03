class EventHandler
  def self.handle_event(address, remote_ip, user_agent, referrer, url, params, domain)

    return if url.host.nil?
    hostname = remove_www(url.host.not_nil!)

    return unless hostname == domain.address

    country = IPCOUNTRY.lookup_cc(remote_ip)

    browser = UserHash.get_browser(user_agent) if user_agent.present?
    user_id = UserHash.create(address, remote_ip, browser.try { |b| b.browser_name } || "", browser.try { |b| b.browser_version } || "").to_s

    temp_source = params.get?(:source)
    source = if !temp_source.nil? && !temp_source.empty? 
                temp_source
              else
                parse_referer_data(referrer)
              end

    browser_data = {
      device: browser.try { |b| b.device_type },
      browser_name: browser.try { |b| b.browser_name },
      browser_version: browser.try { |b| b.browser_version },
      operative_system: browser.try { |b| b.os_name }
    }

    unless EventHandler.is_current_session?(user_id)
      EventHandler.create_session(
        **browser_data,
        user_agent: user_agent,
        referrer: referrer.to_s,
        referrer_domain: referrer.host,
        country: country,
        url: url.to_s,
        path: url.path,
        referrer_source: source,
        domain_id: domain.id,
        user_id: user_id,
        is_bounce: 0
      )
    end
    EventHandler.add_event(
      user_id,
      **browser_data,
      name: "pageview",
      user_agent: user_agent,
      referrer: referrer.to_s,
      country: country,
      referrer_domain: referrer.host,
      url: url.to_s,
      path: url.path,
      referrer_source: source,
      domain_id: domain.id
    )
  end

  def self.is_current_session?(user_id : String)
    session = get_session(user_id)
    return false unless session
    events = EventQuery.new.session_id(session.id).created_at.desc_order
    return false if events.results.size == 0 && session.created_at < SESSION_TIMEOUT.ago
    return true if events.results.size == 0
    return events.first.created_at > SESSION_TIMEOUT.ago
  end

  def self.add_event(user_id : String, **params)
    session = get_session(user_id)
    if session
      SaveEvent.create(**params, user_id: user_id, session_id: session.not_nil!.id) do  |operation, event|
        if event

        else
          raise Avram::InvalidOperationError.new(operation)
        end
      end
    else
      puts "session not found?"
    end
  end

  def self.create_session(**params)
    SaveSession.create!(**params)
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
    uri.lstrip("www.")
  end

  private def self.get_session(user_id : String)
    SessionQuery.new.user_id(user_id).length.is_nil.first
  rescue Avram::RecordNotFoundError
    nil
  end
end
