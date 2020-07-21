class GoalMetrics
  include Percentage
  include ClickDates

  def initialize(@domain : Domain, @from_date : Time, @to_date : Time)
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
  end

  def get_goals : Array(StatsGoal)
    sql = <<-SQL
    SELECT name as goal_name, uniq(user_id) as count FROM kindmetrics.events
    WHERE name!='pageview' AND domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY name
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(goal_name: String, count: UInt64).to_json
    return [] of StatsGoal if json.nil?
    pages = Array(StatsGoal).from_json(json)
    pages = count_percentage(pages)
    return pages
  end
end
