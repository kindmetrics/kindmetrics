class Metrics
  def initialize(@domain : Domain, @period : String)
    @new_metrics = MetricsNew.new(@domain, period_days.to_local_in(Time::Location.load(@domain.time_zone)), Time.local(Time::Location.load(@domain.time_zone)).at_end_of_day)
    @goal_metrics = GoalMetrics.new(@domain, period_days.to_local_in(Time::Location.load(@domain.time_zone)), Time.local(Time::Location.load(@domain.time_zone)).at_end_of_day)
  end

  delegate :current_query, :unique_query, :total_query, :bounce_query, :get_referrers, :get_source_referrers, :get_pages, :get_browsers, :get_os, :get_devices, to: @new_metrics
  delegate :get_source_referrers_total, :path_total_query, :get_countries, :get_countries_map, :path_unique_query, :get_all_referrers, :get_path_referrers, :path_bounce_query, :get_days, to: @new_metrics
  delegate :get_all_medium_referrers, :get_path_medium_referrers, :get_pageviews_days, to: @new_metrics
  delegate :get_goal_stats, :get_all_goals, to: @goal_metrics

  private def period_days : Time
    case @period
    when "14d"
      return 14.days.ago.at_beginning_of_day
    when "30d"
      return 30.days.ago.at_beginning_of_day
    when "60d"
      return 60.days.ago.at_beginning_of_day
    when "90d"
      return 90.days.ago.at_beginning_of_day
    else
      return 7.days.ago.at_beginning_of_day
    end
  end
end
