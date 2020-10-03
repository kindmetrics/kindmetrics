class Domain::SourceSerializer < BaseSerializer
  def initialize(@metrics : Metrics)
  end

  def render
    @metrics.get_all_referrers.map do |source|
      {source: source.referrer_source, medium: source.referrer_medium, visitors: source.count, percentage: ((source.percentage || 0.001)*100).to_i}
    end
  end
end
