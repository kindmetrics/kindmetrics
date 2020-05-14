class Domain < BaseModel
  table do
    column address : String
    column time_zone : String
    belongs_to user : User
  end
end
