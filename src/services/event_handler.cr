class EventHandler

  def self.is_current_session?(user_id : String)
    session = get_session(user_id)
    return false unless session
    return true if session.events.last.created_at < SESSION_TIMEOUT.ago
  end

  def self.add_event(user_id, **params)
    session = get_session(user_id)
    if session
      SaveEvent.create!(**params, user_id: user_id, session_id: session.not_nil!.id)
    end
  end

  def self.create_session(**params)
    SaveSession.create!(**params)
  end

  private def self.get_session(user_id)
    SessionQuery.new.preload_events(EventQuery.new.created_at.asc_order).user_id(user_id).length.is_nil.first
  rescue Avram::RecordNotFoundError
    nil
  end
end
