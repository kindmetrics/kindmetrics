class Domains::Data::Devices::DevicesPage
  include Lucky::HTMLPage
  needs devices : Array(StatsDevice)

  def render
    if devices.empty?
      span class: "block text-center" do
        text "No devices"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent, first_header: "Device", second_header: "Percentage" do
      @devices.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    percentage = ((row.percentage || 0.001)*100)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-8" do
        div class: "w-full h-7" do
          div class: "progress_bar", style: "width: #{percentage}%;height: 30px"
          span class: "block px-2 truncate", style: "margin-top: -1.6rem;" do
            text row.device.to_s
          end
        end
      end
      td class: "w-1/6 h-8 py-1" do
        div class: "text-right" do
          text (percentage.to_i).to_s + "%"
        end
      end
    end
  end
end
