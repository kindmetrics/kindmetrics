class Domains::Countries::IndexPage < Share::BasePage
  quick_def page_title, "Countries for #{@domain.address} last #{period_string}"
  needs share_page : Bool = false
  needs domains : DomainQuery?
  needs active : String = "Countries"
  needs countries : Array(StatsCountry)

  def content
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: @share_page, period_string: period_string, from: from, to: to, active: "Countries"
    div do
      sub_header
      div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row" do
        div class: "card" do
          div data_controller: "country-chart", data_country_chart_period: "7d", data_country_chart_url: "/domains/#{@domain.id}/data/countries_map"
        end
        div class: "card" do
          if countries.size > 0
            m DetailTableComponent, first_header: "Country", second_header: "Visitors" do
              countries.each_with_index do |event, i|
                m TableCountryComponent, event: event, index: i
              end
            end
          end
        end
      end
    end
  end

  def sub_header
    h1 "Countries for #{domain.address}", class: "text-xl"
  end

  def header_url(period)
    if share_page?
      Share::Countries::Index.with(@domain.hashid, from: from, to: to)
    else
      Domains::Countries::Index.with(@domain.id, from: from, to: to)
    end
  end
end
