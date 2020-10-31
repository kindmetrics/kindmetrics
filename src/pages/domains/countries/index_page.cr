class Domains::Countries::IndexPage < Share::BasePage
  quick_def page_title, "Countries for #{@domain.address} last #{period_string}"
  needs share_page : Bool = false
  needs domains : DomainQuery?
  needs active : String = "Countries"
  needs countries : Array(StatsCountry)
  needs languages : Array(StatsLanguage)

  def content
    mount HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: share_page?, current_user: current_user, period_string: period_string, period: period, from: from, to: to, active: "Countries"
    div do
      sub_header
      div class: "card" do
        div data_controller: "country-chart", data_country_chart_from: time_to_string(from), data_country_chart_to: time_to_string(to), data_country_chart_url: "/domains/#{@domain.id}/data/countries_map" do
          div class: "w-20 mx-auto h-80 pt-20" do
            tag "svg", class: "h-20 w-20 inline-block align-middle text-kind-black fill-current", id: "loader-1", space: "preserve", version: "1.1", viewBox: "0 0 50 50", x: "0px", xlink: "http://www.w3.org/1999/xlink", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", d: "M25.251,6.461c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615V6.461z" do
                tag "animateTransform", attributeName: "transform", attributeType: "xml", dur: "0.6s", from: "0 25 25", repeatCount: "indefinite", to: "360 25 25", type: "rotate"
              end
            end
          end
        end
      end
      div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row mt-6" do
        div class: "card" do
          if languages.size > 0
            mount DetailTableComponent, first_header: "Language", second_header: "Visitors" do
              languages.each_with_index do |event, i|
                mount TableLanguageComponent, event: event, index: i
              end
            end
          end
        end
        div class: "card" do
          if countries.size > 0
            mount DetailTableComponent, first_header: "Country", second_header: "Visitors" do
              countries.each_with_index do |event, i|
                mount TableCountryComponent, event: event, index: i
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
      Share::Countries::Index.with(@domain.hashid, from: time_to_string(from), to: time_to_string(to))
    else
      Domains::Countries::Index.with(@domain.id, from: time_to_string(from), to: time_to_string(to))
    end
  end
end
