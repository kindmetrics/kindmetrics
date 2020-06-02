module DomainMetrics
  def unique_query(domain)
    metrics(domain).unique_query
  end

  def total_query(domain)
    metrics(domain).total_query
  end

  def bounce_query(domain)
    metrics(domain).bounce_query
  end

  def metrics(domain)
    @metrics ||= Metrics.new(domain, period)
  end
end
