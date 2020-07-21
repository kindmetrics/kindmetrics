class GoalMetrics
  include Percentage
  include ClickDates

  def initialize(@domain : Domain, @from_date : Time, @to_date : Time)
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
  end

  def get_goals : Array(Goal)
    sql = <<-SQL
    SELECT name as goal_name, uniq(user_id) as count FROM kindmetrics.events
    WHERE name!='pageview' AND domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}'
    GROUP BY name
    ORDER BY count desc
    SQL
    res = @client.execute(sql)
    json = res.map_nil(goal_name: String, count: UInt64).to_json
    return [] of Goal if json.nil?
    pages = Array(Goal).from_json(json)
    pages = count_percentage(pages)
    pages = count_bounce_rate_goal(pages)
    return pages
  end

  def bounce_query_goal(goal : String) : Int64
    sql = <<-SQL
    SELECT round(sum(is_bounce * mark) / sum(mark) * 100) as bounce_rate
    FROM kindmetrics.sessions WHERE domain_id=#{@domain.id} AND created_at > '#{slim_from_date}' AND created_at < '#{slim_to_date}' AND name='#{goal}'
    SQL
    res = @client.execute(sql)
    bounce = res.data.first.first.as_i64?
    return 0.to_i64 if bounce.nil?
    bounce.not_nil!.to_i64
  end
end
