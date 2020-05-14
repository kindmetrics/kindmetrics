class Event < BaseModel
  table do
    column user_id : String
    column name : String
    column referrer : String?
    column domain : String?
    column url : String?
    column source : String?
    column user_agent : String?
    column screen_width : String?
    belongs_to domain : Domain
  end
end
