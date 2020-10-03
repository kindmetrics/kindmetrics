class ApiToken < BaseModel
  table do
    column token : String
    belongs_to user : User
  end
end
