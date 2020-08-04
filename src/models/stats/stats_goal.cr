class StatsGoal
  include JSON::Serializable

  property goal_name : String

  # @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?

  def initialize(@goal_name, @count : Int64)
  end
end
