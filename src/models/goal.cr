class Goal < BaseModel

  avram_enum Kind do
    Event = 0
    Path  = 1
  end

  table do
    column name : String
    column kind : Int32
    column sort : Int32
    belongs_to domain : Domain
  end
end
