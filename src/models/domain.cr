class Domain < BaseModel
  include Hashid

  table do
    column address : String
    column time_zone : String
    column shared : Bool
    belongs_to user : User
    has_many sessions : Session
    has_many events : Event
  end

  def hashid
    hashids.encode([id])
  end

  def shared?
    true
  end
end
