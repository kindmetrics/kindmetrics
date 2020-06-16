module DomainMetrics
  def unique_query(domain) : Int64
    metrics(domain).unique_query
  end

  def total_query(domain) : Int64
    metrics(domain).total_query
  end

  def bounce_query(domain) : Int64
    metrics(domain).bounce_query
  end

  def metrics(domain) : Metrics
    @metrics ||= Metrics.new(domain, period)
  end

  def unique_query_previous(domain) : Int64
    previous_metric(domain).unique_query
  end

  def total_query_previous(domain) : Int64
    previous_metric(domain).total_query
  end

  def bounce_query_previous(domain) : Int64
    previous_metric(domain).bounce_query
  end

  def previous_metric(domain) : MetricsNew
    start_date, end_date = previous_period
    @previous_metrics ||= MetricsNew.new(domain, start_date, end_date)
  end

  private def previous_period
    case period
    when "14d"
      start_date = 15.days.ago.at_end_of_day
      return [start_date - 14.days, start_date]
    when "30d"
      start_date = 31.days.ago.at_end_of_day
      return [start_date - 30.days, start_date]
      return "30 days"
    when "60d"
      start_date = 61.days.ago.at_end_of_day
      return [start_date - 60.days, start_date]
    when "90d"
      start_date = 91.days.ago.at_end_of_day
      return [start_date - 90.days, start_date]
    else
      start_date = 8.days.ago.at_end_of_day
      return [start_date - 7.days, start_date]
    end
  end
end
