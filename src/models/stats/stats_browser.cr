struct StatsBrowser
  include JSON::Serializable

  property browser : String?

  @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?
end
