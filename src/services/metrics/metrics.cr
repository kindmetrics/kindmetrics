class Metrics
  def initialize(@domain : Domain, from : Time, to : Time, @goal : Goal? = nil, @path : String = "", @source : String = "", @medium : String = "")
    @new_metrics = MetricsNew.new(@domain, from.to_local_in(Time::Location.load(@domain.time_zone)), to.to_local_in(Time::Location.load(@domain.time_zone)).at_end_of_day, @goal, @path, @source, @medium)
    @goal_metrics = GoalMetrics.new(@domain, from.to_local_in(Time::Location.load(@domain.time_zone)), to.to_local_in(Time::Location.load(@domain.time_zone)).at_end_of_day)
  end

  delegate :current_query, :unique_query, :total_query, :bounce_query, :get_sources, :get_referrers, :get_pages, :get_browsers, :get_os, :get_devices, to: @new_metrics
  delegate :get_source_referrers_total, :path_total_query, :get_countries, :get_countries_map, :path_unique_query, :get_all_referrers, :path_bounce_query, :get_days, to: @new_metrics
  delegate :get_all_medium_referrers, :get_pageviews_days, to: @new_metrics
  delegate :real_count, to: @new_metrics
  delegate :get_goal_stats, :get_all_goals, to: @goal_metrics
end
