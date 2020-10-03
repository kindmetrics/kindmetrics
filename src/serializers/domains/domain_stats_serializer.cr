class DomainStatsSerializer < BaseSerializer
  def initialize(@domain : Domain, @metrics : Metrics)
  end

  def render
    snippet = <<-HTML
    <script src="https://#{KindEnv.env("APP_TRACK_HOST")}/js/kind.js" defer="true" data-domain="#{@domain.address}"></script>
    HTML
    {
      address:       @domain.address,
      visitors:      @metrics.unique_query,
      pageviews:     @metrics.total_query,
      bounce:        @metrics.bounce_query,
      track_snippet: snippet,
    }
  end
end
