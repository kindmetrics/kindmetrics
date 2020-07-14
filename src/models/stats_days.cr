class StatsDays
  include JSON::Serializable

  property date : Time

  property count : Int64?

  def initialize(@date : Time, @count : Int64)
  end
end
