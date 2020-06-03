class CountriesSerializer < BaseSerializer
  def initialize(@countries : Array(StatsCountry) | Nil)
    @parser = FindCountry.new
  end

  def render
    if @countries.nil?
      {} of String => String
    else
      {data: @countries.not_nil!.map { |c| {country: get_country_code(c.country), count: c.count} }}
    end
  end

  def get_country_code(cc)
    return nil if cc.nil?
    response = @parser.find_by_cc(cc.not_nil!)
    return nil if response.nil?
    response["iso3"].as_s
  end
end
