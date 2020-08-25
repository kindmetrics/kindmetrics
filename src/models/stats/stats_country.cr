struct StatsCountry
  include JSON::Serializable

  property country : String?
  property country_name : String?

  @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?
end
