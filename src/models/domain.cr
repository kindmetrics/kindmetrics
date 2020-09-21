class Domain < BaseModel
  include Hashid

  table do
    column address : String
    column time_zone : String
    column shared : Bool
    belongs_to user : User
  end

  def hashid
    hashids.encode([id])
  end

  def sessions : Array(Session)
    AddClickhouse.get_domain_sessions(id)
  end

  def events : Array(Event)
    AddClickhouse.get_domain_events(id)
  end
end
