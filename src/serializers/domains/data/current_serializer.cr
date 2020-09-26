class Domain::CurrentSerializer < BaseSerializer
  def initialize(@metrics : Metrics)
  end

  def render
    {current: @metrics.current_query}
  end
end
