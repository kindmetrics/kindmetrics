class Metrics
  def initialize(@domain : Domain, @period : String)
    @new_metrics = MetricsNew.new(@domain, period_days, Time.local.at_end_of_day)
  end

  delegate :current_query, :unique_query, :total_query, :bounce_query, :get_referrers, :get_source_referrers, :get_pages, :get_browsers, :get_os, :get_devices, to: @new_metrics
  delegate :get_source_referrers_total, :path_total_query, :get_countries, :get_countries_map, :path_unique_query, :get_all_referrers, :get_path_referrers, :path_bounce_query, :get_days, to: @new_metrics

  private def period_days : Time
    case @period
    when "14d"
      return 13.days.ago.at_beginning_of_day
    when "30d"
      return 29.days.ago.at_beginning_of_day
    when "60d"
      return 59.days.ago.at_beginning_of_day
    when "90d"
      return 89.days.ago.at_beginning_of_day
    else
      return 6.days.ago.at_beginning_of_day
    end
  end

  private def count_percentage(array)
    total = array.sum { |p| p.count }
    array.map do |p|
      p.percentage = p.count / total.to_f32
      p
    end
  end
end
