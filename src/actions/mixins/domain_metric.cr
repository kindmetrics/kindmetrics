module PreviousDomainMetrics
  def previous_metric : MetricsNew
    start_date, end_date = previous_period
    @previous_metrics ||= MetricsNew.new(domain, start_date, end_date, goal, site_path, source_name, medium_name)
  end

  private def previous_period
    time_span = to_previous_time - from_previous_time
    days = time_span.days

    start_date = from_previous_time - (days + 1).days
    end_date = from_previous_time - 1.day
    [start_date, end_date]
  end

  def from_previous_time : Time
    if from.is_a?(String)
      string_to_date(from).as(Time)
    else
      from.as(Time)
    end
  end

  def to_previous_time : Time
    if to.is_a?(String)
      string_to_date(to).as(Time)
    else
      to.as(Time)
    end
  end
end
