class TimeWorker
  def self.check
    sessions = get_sessions
    if sessions.size == 0
      puts "no sessions to check this time.."
    end
    sessions.each do |s|
      timedout(s)
    end
  end

  def self.timedout(session : Session)
    events = EventQuery.new.session_id(session.id).created_at.asc_order
    pp! events.results.size
    local = session.domain.time_zone
    pp! events.last.created_at if events.results.size > 0
    pp! SESSION_TIMEOUT.ago
    not_done = if events.results.size > 0
                events.last.created_at > SESSION_TIMEOUT.ago
              else
                true
              end
    pp! not_done
    if not_done
      puts "not yet timedout"
      puts "--"
      return
    end
    timespent = events.first.created_at - events.last.created_at
    pp! timespent
    is_bounce = events.results.size == 1
    puts "saving session #{session.id} on domain: #{session.domain.not_nil!.address}"
    SaveSession.update!(session, length: timespent.seconds.to_i64, is_bounce: is_bounce)
  end


  def self.get_sessions
    SessionQuery.new.preload_domain.length.is_nil
  end
end
