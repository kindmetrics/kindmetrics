class Domain::GoalSerializer < BaseSerializer
  def initialize(@metrics : GoalMetrics)
  end

  def render
    @metrics.get_all_goals.map do |g|
      {name: g[:goal].name, kind: Goal::Kind.new(g[:goal].kind).enum.to_s, conversions: g[:stats_goal].count}
    end
  end
end
