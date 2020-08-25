struct StatsPages
  include JSON::Serializable

  property address : String?

  @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?
end
