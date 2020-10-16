class GoalMetrics
  include Percentage
  include ClickDates

  def initialize(@domain : Domain, @from_date : Time, @to_date : Time, @path : String? = nil, @source : String? = nil, @medium : String? = nil)
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
  end

  def get_all_goals
    goals = GoalQuery.new.domain_id(@domain.id)
    stats_goals = [] of {goal: Goal, stats_goal: StatsGoal}
    goals.each do |g|
      gg = get_goal_stats(g)

      gg = StatsGoal.new(goal_name: "", count: 0) if gg.nil?

      gg.goal_name = if g.kind == 0
                       "Trigger " + g.name
                     else
                       "Visit " + g.name
                     end
      stats_goals << {stats_goal: gg, goal: g}
    end
    stats_goals.sort! { |x, y| y[:stats_goal].count <=> x[:stats_goal].count }
    count_array_percentage(stats_goals)
  end

  def get_goal_stats(goal : Goal) : StatsGoal?
    sql = if goal.kind == 0
            <<-SQL
      SELECT name as goal_name, uniq(user_id) as count FROM kindmetrics.events
      WHERE name='#{goal.name}' AND domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
      #{where_path_string}
      #{where_source_string}
      #{where_medium_string}
      GROUP BY name
      ORDER BY count desc
      SQL
          else
            <<-SQL
      SELECT name as goal_name, uniq(user_id) as count FROM kindmetrics.events
      WHERE domain_id=#{@domain.id} AND path='#{goal.name}' AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
      #{where_path_string}
      #{where_source_string}
      #{where_medium_string}
      GROUP BY name
      ORDER BY count desc
      SQL
          end
    res = @client.execute(sql)
    json = res.map_nil(goal_name: String, count: UInt64).to_json
    return nil if json.nil?
    pages = Array(StatsGoal).from_json(json)
    return nil if pages.empty?
    pages.first
  end

  private def where_path_string
    return if @path.nil?

    "AND path=#{PG::EscapeHelper.escape_literal(@path.not_nil!.strip)}"
  end

  private def where_source_string
    return if @source.nil?

    "AND referrer_source=#{PG::EscapeHelper.escape_literal(@source.not_nil!.strip)}"
  end

  private def where_medium_string
    return if @medium.nil?

    "AND referrer_medium=#{PG::EscapeHelper.escape_literal(@medium.not_nil!.strip)}"
  end
end
