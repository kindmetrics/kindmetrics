class ClickEvent
  include JSON::Serializable

  @[JSON::Field(converter: JSON::IntConverter)]
  property id : Int64

  property user_id : String
  property name : String
  property referrer : String?
  property domain : String?
  property url : String?
  property referrer_source : String?
  property path : String?
  property device : String?
  property operative_system : String?
  property referrer_domain : String?
  property browser_name : String?
  property country : String?

  @[JSON::Field(converter: JSON::IntConverter)]
  property domain_id : Int64

  @[JSON::Field(converter: JSON::IntConverter)]
  property session_id : Int64

  @[JSON::Field(converter: JSON::ClickTimeConverter)]
  property created_at : Time
end
