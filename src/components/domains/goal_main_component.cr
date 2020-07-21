class GoalMainComponent < BaseComponent
  needs goal : StatsGoal
  needs index : Int32
  needs current_user : User?
  needs current_domain : Domain
  needs period : String

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td class: "w-4/6 py-2" do
        a class: "block px-2 hover:underline truncate", href: "#" do
          text goal.goal_name
        end
      end
      td class: "w-1/6 p-2" do
        text goal.count.to_s
      end
    end
  end
end
