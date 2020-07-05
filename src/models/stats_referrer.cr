class StatsReferrer
  include JSON::Serializable

  property referrer_source : String?
  property referrer_domain : String?
  property referrer_medium : String?
  property count : Int64
  property percentage : Float32?
end
