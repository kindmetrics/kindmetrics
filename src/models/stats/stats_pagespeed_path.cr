struct StatsPagespeedPath
  include JSON::Serializable

  property address : String?

  property page_load : Float64

  property percentage : Float32?
end
