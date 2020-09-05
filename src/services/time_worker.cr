class TimeWorker
  L = Log.for("worker")

  def self.check
    sessions = get_sessions
    time_check = Time.utc - SESSION_TIMEOUT
    if sessions.size == 0
      L.info { "no sessions to check this time.." }
    end
    sessions.each do |s|
      next if s.created_at > time_check
      spawn session_time_check(s.id)
    end
  end

  def self.session_time_check(session_id : Int64)
    events = AddClickhouse.get_events(session_id)

    return fix_empty_session(session_id) if events.size == 0

    last_event = events.last
    first_event = events.first

    time_spent = last_event.created_at - first_event.created_at
    time_spent_seconds = time_spent.total_seconds.to_i64

    time_check = Time.utc - SESSION_TIMEOUT

    not_done = if events.size > 0
                 last_event.created_at > time_check
               else
                 true
               end

    if not_done
      L.info { "not yet timedout" }
      L.info { "--" }
      return
    end

    is_bounce = events.size == 1 ? 1 : 0
    L.info { "saving session #{session_id}" }

    AddClickhouse.update_session(session_id, length: time_spent_seconds, is_bounce: is_bounce)
  end

  def self.fix_empty_session(session_id : Int64)
    session = AddClickhouse.get_session_by_id(session_id)
    return if session.nil?

    session = session.not_nil!

    time_check = Time.utc - SESSION_TIMEOUT
    return if session.created_at > time_check

    AddClickhouse.event_insert(
      user_id: session.user_id,
      name: session.name,
      referrer: session.referrer,
      url: session.url,
      referrer_source: session.referrer_source,
      referrer_medium: session.referrer_medium,
      path: session.path,
      device: session.device,
      operative_system: session.operative_system,
      referrer_domain: session.referrer_domain,
      browser_name: session.browser_name,
      country: session.country,
      domain_id: session.domain_id,
      session_id: session_id,
      created_at: session.created_at
    )

    AddClickhouse.update_session(session_id, length: 0, is_bounce: 1)
  end

  def self.get_sessions : Array(ClickSession)
    AddClickhouse.get_active_sessions
  end
end
