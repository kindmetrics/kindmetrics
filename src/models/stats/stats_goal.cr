class StatsGoal
  include JSON::Serializable

  property goal_name : String

  # @[JSON::Field(converter: JSON::IntConverter)]
  property count : Int64

  property percentage : Float32?
end
