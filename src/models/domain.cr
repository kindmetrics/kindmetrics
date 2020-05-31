class Domain < BaseModel
  table do
    column address : String
    column time_zone : String
    column shared : Bool
    belongs_to user : User
    has_many sessions : Session
    has_many events : Event
  end

  def shared?
    true
  end
end
