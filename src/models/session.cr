class Session < BaseModel
  table do
    column user_id : String
    column referrer : String?
    column url : String?
    column source : String?
    column user_agent : String?
    column screen_width : String?
    column path : String?
    column device : String?
    column operative_system : String?
    column referrer_domain : String?
    column browser_name : String?
    column browser_version : String?
    column country : String?
    column length : Int64?
    column is_bounce : Int32
    belongs_to domain : Domain
    has_many events : Event
  end
end
