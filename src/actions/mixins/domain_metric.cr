module PreviousDomainMetrics
  def previous_metric : MetricsNew
    start_date, end_date = previous_period
    @previous_metrics ||= MetricsNew.new(domain, start_date, end_date, goal, site_path, source_name, medium_name)
  end

  private def previous_period
    case period
    when "14d"
      start_date = 15.days.ago.at_end_of_day
      [start_date - 14.days, start_date]
    when "30d"
      start_date = 31.days.ago.at_end_of_day
      [start_date - 30.days, start_date]
    when "60d"
      start_date = 61.days.ago.at_end_of_day
      [start_date - 60.days, start_date]
    when "90d"
      start_date = 91.days.ago.at_end_of_day
      [start_date - 90.days, start_date]
    else
      start_date = 8.days.ago.at_end_of_day
      [start_date - 7.days, start_date]
    end
  end
end
