struct StatsOS
  include JSON::Serializable

  property operative_system : String?

  @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?
end
