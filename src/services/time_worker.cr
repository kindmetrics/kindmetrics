class TimeWorker
  L = Log.for("worker")
  def self.check
    sessions = get_sessions
    if sessions.size == 0

      L.info { "no sessions to check this time.." }
    end
    sessions.each do |s|
      timedout(s)
    end
  end

  def self.timedout(session : Session)
    events = EventQuery.new.session_id(session.id).created_at.asc_order

    return false if events.results.size == 0

    last_event = events.results.last
    first_event = events.results.first

    timespent = last_event.created_at - first_event.created_at
    timespent_seconds = timespent.total_seconds.to_i64

    not_done = if events.results.size > 0
                 last_event.created_at > SESSION_TIMEOUT.ago
               else
                 true
               end

    if not_done
      L.info { "not yet timedout" }
      L.info { "--" }
      return
    end

    is_bounce = events.results.size == 1 ? 1 : 0
    L.info { "saving session #{session.id} on domain: #{session.domain!.not_nil!.address}" }
    SaveSession.update!(session, length: timespent_seconds, is_bounce: is_bounce)
  end

  def self.get_sessions
    SessionQuery.new.preload_domain.length.is_nil
  end
end
