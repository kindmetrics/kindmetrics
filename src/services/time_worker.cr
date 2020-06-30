class TimeWorker
  L = Log.for("worker")

  def self.check
    sessions = get_sessions
    if sessions.size == 0
      L.info { "no sessions to check this time.." }
    end
    sessions.each do |s|
      spawn timedout(s["id"])
    end
  end

  def self.timedout(session_id : UInt64)
    events = AddClickhouse.get_events(session_id)

    return false if events.size == 0

    last_event = events.last
    first_event = events.first

    timespent = last_event["created_at"] - first_event["created_at"]
    timespent_seconds = timespent.total_seconds.to_i64

    not_done = if events.size > 0
                 last_event["created_at"] > SESSION_TIMEOUT.ago
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
    AddClickhouse.update_session(session_id.to_i64, length: timespent_seconds, is_bounce: is_bounce)
  end

  def self.get_sessions
    AddClickhouse.get_active_sessions
  end
end
