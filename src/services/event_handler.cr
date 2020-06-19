class EventHandler
  def self.handle_event(address, remote_ip, user_agent, referrer, url, params, domain)
    return if url.host.nil?
    hostname = remove_www(url.host.not_nil!)

    if Lucky::Env.production?
      return unless hostname.ends_with?(domain.address)
    end

    country = IPCOUNTRY.lookup_cc(remote_ip)

    browser = UserHash.get_browser(user_agent) if user_agent.present?
    temp_user_id = UserHash.temp_create(address, remote_ip, user_agent).to_s

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
      device:           browser.try { |b| b.device_type },
      browser_name:     browser.try { |b| b.browser_name },
      operative_system: browser.try { |b| b.os_name },
    }

    unless is_current_session?(temp_user_id)
      create_session(
        **browser_data,
        temp_user_id: temp_user_id,
        remote_ip: remote_ip,
        user_agent: user_agent,
        referrer: referrer.to_s,
        referrer_domain: referrer.host,
        country: country,
        url: url.to_s,
        path: url.path,
        referrer_source: source,
        domain_id: domain.id,
        is_bounce: 0,
        length: nil
      )
    else
      add_event(
        temp_user_id,
        **browser_data,
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

  def self.is_current_session?(temp_user_id : String)
    session = get_session(temp_user_id)
    return false unless session
    events = EventQuery.new.session_id(session.id).created_at.desc_order
    return false if events.results.size == 0 && session.created_at < SESSION_TIMEOUT.ago
    return true if events.results.size == 0
    return events.first.created_at > SESSION_TIMEOUT.ago
  end

  def self.add_event(temp_user_id : String, **params)
    session = get_session(temp_user_id)
    if session
      SaveEvent.create(**params, session_id: session.not_nil!.id) do |operation, event|
        unless event
          raise Avram::InvalidOperationError.new(operation)
        end
      end
    else
      puts "session not found?"
    end
  end

  def self.create_session(**params)
    CreateSession.create!(**params)
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

  private def self.get_session(temp_user_id : String)
    SessionQuery.new.temp_user_id(temp_user_id).length.is_nil.first
  rescue Avram::RecordNotFoundError
    nil
  end
end
