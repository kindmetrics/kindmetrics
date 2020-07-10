class Domains::Data::CountriesPage
  include Lucky::HTMLPage
  needs countries : Array(StatsCountry)

  def render
    if countries.empty?
      span class: "block text-center" do
        text "No pages"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent.new(first_header: "Country", second_header: "Visitors") do
      @countries.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    tr class: "h-10 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-2 h-10" do
        div class: "w-full h-10" do
          div class: "progress_bar", style: "width: #{(row.percentage || 0.001)*100}%;height: 30px"
          span class: "block px-2 truncate", style: "margin-top: -1.6rem;" do
            text (row.country_name || row.country).to_s
          end
        end
      end
      td class: "w-1/6 h-10 py-2" do
        div class: "-mt-4 text-right" do
          text row.count
        end
      end
    end
  end
end
