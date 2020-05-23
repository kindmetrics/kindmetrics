class Domains::Data::CountriesPage
  include Lucky::HTMLPage
  needs countries : Array(StatsCountry)

  def render
    if countries.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/countries"
    end
  end
end
