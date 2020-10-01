module PreviousDomainMetrics
  def previous_metric : Metrics
    start_date, end_date = previous_period
    @previous_metrics ||= Metrics.new(domain, start_date, end_date, goal, site_path, source_name, medium_name)
  end

  private def previous_period
    time_span = real_to - real_from
    days = time_span.days

    start_date = real_from - (days + 1).days
    end_date = real_from - 1.day
    [start_date, end_date]
  end
end
