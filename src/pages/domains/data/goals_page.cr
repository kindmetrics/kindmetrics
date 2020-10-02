class Domains::Data::GoalsPage < Domains::Data::BasePage
  needs goals : Array(NamedTuple(goal: Goal, stats_goal: StatsGoal))

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
        render_row(r[:stats_goal], r[:goal])
      end
    end
  end

  def render_row(row : StatsGoal, goal : Goal)
    percentage = ((row.percentage || 0.001)*100)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-8" do
        div class: "w-full h-7" do
          div class: "progress_bar", style: "width: #{percentage}%;height: 30px"
          span class: "block px-2 truncate", style: "margin-top: -1.6rem;" do
            if row.count > 0
              link row.goal_name.to_s, to: current_user.nil? ? Share::Show.with(share_id: domain.hashid, goal_id: goal.id, source_name: source_name, medium_name: medium_name, from: time_to_string(from), to: time_to_string(to)) : Domains::Show.with(domain_id: domain.id, goal_id: goal.id, source_name: source_name, medium_name: medium_name, from: time_to_string(from), to: time_to_string(to))
            else
              text row.goal_name.to_s
            end
          end
        end
      end
      td class: "w-1/6 h-8 py-1" do
        div class: "text-right" do
          text (row.count.to_i).to_s
        end
      end
    end
  end
end
