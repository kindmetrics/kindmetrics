struct ClickSession
  include JSON::Serializable

  @[JSON::Field(converter: JSON::IntConverter)]
  property id : Int64

  property name : String
  property user_id : String
  property referrer : String?
  property url : String?
  property path : String?
  property device : String?
  property operative_system : String?

  property referrer_source : String?
  property referrer_domain : String?
  property referrer_medium : String?

  property browser_name : String?
  property country : String?
  property is_bounce : Int32

  @[JSON::Field(converter: JSON::IntConverter)]
  property length : Int64?

  @[JSON::Field(converter: JSON::IntConverter)]
  property domain_id : Int64

  @[JSON::Field(converter: JSON::ClickTimeConverter)]
  property created_at : Time
end
