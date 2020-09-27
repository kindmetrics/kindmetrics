class Domain::SourceSerializer < BaseSerializer
  def initialize(@domain : Domain, @metrics : Metrics)
  end

  def render
    @metrics.get_all_referrers.map do |source|
      {source: source.referrer_source, domain: source.referrer_domain, medium: source.referrer_medium, visitors: source.count, percentage: source.percentage}
    end
  end
end
