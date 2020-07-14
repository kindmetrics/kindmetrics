class StatsReferrer
  include JSON::Serializable

  property referrer_source : String?
  property referrer_domain : String?
  property referrer_medium : String?
  property referrer_url : String?
  property count : Int64
  property bounce_rate : Int64?
  property percentage : Float32?
end
