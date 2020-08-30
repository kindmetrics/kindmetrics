class TimeWorker
  L = Log.for("worker")

  def self.check
    sessions = get_sessions
    if sessions.size == 0
      L.info { "no sessions to check this time.." }
    end
    sessions.each do |s|
      spawn session_time_check(s.id)
    end
  end

  def self.session_time_check(session_id : Int64)
    events = AddClickhouse.get_events(session_id)

    return false if events.size == 0

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

    AddClickhouse.update_session(session_id.to_i64, length: time_spent_seconds, is_bounce: is_bounce)
  end

  def self.get_sessions
    AddClickhouse.get_active_sessions
  end
end
