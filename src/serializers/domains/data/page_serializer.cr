class Domain::PageSerializer < BaseSerializer
  def initialize(@domain : Domain, @metrics : Metrics)
  end

  def render
    @metrics.get_pages.map do |path|
      {address: path.address, visitors: path.count}
    end
  end
end
