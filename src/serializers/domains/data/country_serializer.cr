class Domain::CountrySerializer < BaseSerializer
  def initialize(@metrics : Metrics)
  end

  def render
    @metrics.get_countries.map do |c|
      {name: c.country_name, visitors: c.count, percentage: ((c.percentage || 0.001)*100).to_i}
    end
  end
end
