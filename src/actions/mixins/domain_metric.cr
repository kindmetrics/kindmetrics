module DomainMetrics
  def unique_query(domain, goal : Goal? = nil, path : String = "") : Int64
    metrics(domain, goal, path).unique_query
  end

  def total_query(domain, goal : Goal? = nil, path : String = "") : Int64
    metrics(domain, goal, path).total_query
  end

  def bounce_query(domain, goal : Goal? = nil, path : String = "") : Int64
    metrics(domain, goal, path).bounce_query
  end

  def metrics(domain, goal : Goal? = nil, path : String = "") : Metrics
    @metrics ||= Metrics.new(domain, period, goal, path)
  end

  def unique_query_previous(domain, goal : Goal? = nil, path : String = "") : Int64
    previous_metric(domain, goal, path).unique_query
  end

  def total_query_previous(domain, goal : Goal? = nil, path : String = "") : Int64
    previous_metric(domain, goal, path).total_query
  end

  def bounce_query_previous(domain, goal : Goal? = nil, path : String = "") : Int64
    previous_metric(domain, goal, path).bounce_query
  end

  def previous_metric(domain, goal : Goal? = nil, path : String = "") : MetricsNew
    start_date, end_date = previous_period
    @previous_metrics ||= MetricsNew.new(domain, start_date, end_date, goal, path)
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
