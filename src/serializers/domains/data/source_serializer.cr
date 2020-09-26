class Domain::SourceSerializer < BaseSerializer
  def initialize(@domain : Domain, @metrics : Metrics)
  end

  def render
    @metrics.get_sources.map do |source|
      {source: source.referrer_source, domain: source.referrer_domain, medium: source.referrer_medium, visitors: source.count}
    end
  end
end
