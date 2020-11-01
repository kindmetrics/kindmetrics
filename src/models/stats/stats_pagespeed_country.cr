struct StatsPagespeedCountry
  include JSON::Serializable

  property country : String?
  property country_name : String?

  property page_load : Float64

  property percentage : Float32?
end
