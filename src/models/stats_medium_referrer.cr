class StatsMediumReferrer
  include JSON::Serializable

  property referrer_medium : String?
  property count : Int64
  property bounce_rate : Int64?
  property percentage : Float32?
end
