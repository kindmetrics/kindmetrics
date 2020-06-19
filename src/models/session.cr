class Session < BaseModel
  table do
    column user_id : String
    column temp_user_id : String?
    column referrer : String?
    column url : String?
    column referrer_source : String?
    column screen_width : String?
    column path : String?
    column device : String?
    column operative_system : String?
    column referrer_domain : String?
    column browser_name : String?
    column country : String?
    column length : Int64?
    column is_bounce : Int32
    belongs_to domain : Domain
    has_many events : Event
  end
end
