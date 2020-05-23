class TimeWorker
  def self.check
    sessions = get_sessions
    sessions.each do |s|
      timedout(s)
    end
  end

  def self.timedout(session : Session)
    events = EventQuery.new.session_id(session.id).created_at.asc_order
    if events.last.created_at < SESSION_TIMEOUT.ago
      puts "not yet timedout"
      return
    end
    is_bounce = events.size == 1
    time_between = if events.size == 1
      Time::Span.new(seconds: 0)
    else
      events.last.created_at - events.first.created_at
    end
    SaveSession.update!(session, length: time_between.seconds.to_i64, is_bounce: is_bounce)
  end


  def self.get_sessions
    SessionQuery.new.length.is_nil
  end
end
