class StatsPages
  include JSON::Serializable

  property address : String?

  property count : Int64
  property percentage : Float32?
end
