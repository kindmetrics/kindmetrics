class Event < BaseModel
  table do
    column user_id : String
    column name : String
    column referrer : String?
    column domain : String?
    column url : String?
    column referrer_source : String?
    column screen_width : String?
    column path : String?
    column device : String?
    column operative_system : String?
    column referrer_domain : String?
    column browser_name : String?
    column browser_version : String?
    column country : String?
    belongs_to domain : Domain
    belongs_to session : Session?
  end
end
