class Domain::ReferrerSerializer < BaseSerializer
  def initialize(@metrics : Metrics)
  end

  def render
    @metrics.get_referrers(0).map do |source|
      {url: source.referrer_url, domain: source.referrer_domain, visitors: source.count, percentage: ((source.percentage || 0.001)*100).to_i}
    end
  end
end
