struct StatsLanguage
  include JSON::Serializable

  property language : String?
  property language_name : String?

  @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?
end
