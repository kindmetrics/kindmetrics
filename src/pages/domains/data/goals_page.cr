class Domains::Data::GoalsPage
  include Lucky::HTMLPage
  needs goals : Array(StatsGoal)

  def render
    unless goals.empty?
      div class: "w-full grid grid-cols-1 md:grid-cols-1 gap-6 mt-6" do
        div class: "card" do
          render_table
        end
      end
    end
  end

  def render_table
    m DashboardTableComponent, first_header: "Goal", second_header: "Conversions" do
      @goals.each do |r|
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
            text row.goal_name.to_s
          end
        end
      end
      td class: "w-1/6 h-9 py-1" do
        div class: "mt-1 text-right" do
          text (row.count.to_i).to_s
        end
      end
    end
  end
end