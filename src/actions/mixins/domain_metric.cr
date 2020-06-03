module DomainMetrics
  def unique_query(domain) : String
    metrics(domain).unique_query
  end

  def total_query(domain) : String
    metrics(domain).total_query
  end

  def bounce_query(domain) : String
    metrics(domain).bounce_query
  end

  def metrics(domain) : Metrics
    @metrics ||= Metrics.new(domain, period)
  end
end
