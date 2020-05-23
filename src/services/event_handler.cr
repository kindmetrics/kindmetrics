class EventHandler

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

  private def self.get_session(user_id : String)
    SessionQuery.new.user_id(user_id).length.is_nil.first
  rescue Avram::RecordNotFoundError
    nil
  end
end
