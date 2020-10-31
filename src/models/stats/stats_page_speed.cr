struct StatsPageSpeed
  include JSON::Serializable

  property date : Time

  property page_load : Int64?

  property page_load_sec : Float64?

  def initialize(@date : Time, @page_load_sec : Float64? = nil)
  end
end
