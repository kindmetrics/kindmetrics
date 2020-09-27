class Domain::PageSerializer < BaseSerializer
  def initialize(@domain : Domain, @metrics : Metrics)
  end

  def render
    @metrics.get_pages(0).map do |path|
      {address: path.address, visitors: path.count, percentage: path.percentage}
    end
  end
end
