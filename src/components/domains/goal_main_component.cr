class GoalMainComponent < BaseComponent
  include Timeparser
  needs stats_goal : StatsGoal
  needs goal : Goal
  needs index : Int32
  needs current_user : User?
  needs current_domain : Domain
  needs from : Time
  needs to : Time

  def render
    tr class: index.odd? ? "bg-gray-100" : "bg-white" do
      td class: "w-4/6 py-2" do
        if stats_goal.count > 0
          link to: Domains::Show.with(current_domain, goal_id: goal.id, to: time_to_string(to), from: time_to_string(from)), class: "block px-2 hover:underline truncate" do
            text stats_goal.goal_name
          end
        else
          span class: "px-2" do
            text stats_goal.goal_name
          end
        end
      end
      td class: "w-1/6 p-2" do
        text stats_goal.count.to_s
      end
    end
  end
end
