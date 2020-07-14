class Domains::Data::Devices::BrowsersPage
  include Lucky::HTMLPage
  needs browsers : Array(StatsBrowser)

  def render
    if browsers.empty?
      span class: "block text-center" do
        text "No browsers"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent.new(first_header: "Browser", second_header: "Percentage") do
      @browsers.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    percentage = ((row.percentage || 0.001)*100)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-9" do
        div class: "w-full h-9" do
          div class: "progress_bar", style: "width: #{percentage}%;height: 30px"
          span class: "block px-2 truncate", style: "margin-top: -1.6rem;" do
            text row.browser.to_s
          end
        end
      end
      td class: "w-1/6 h-9 py-1" do
        div class: "mt-1 text-right" do
          text (percentage.to_i).to_s + "%"
        end
      end
    end
  end
end
