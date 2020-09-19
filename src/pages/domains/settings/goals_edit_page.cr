class Domains::EditGoalsPage < AdminLayout
  needs operation : SaveGoal
  needs domain : Domain
  needs goals : GoalQuery
  needs hashid : String
  needs share_page : Bool = false
  quick_def page_title, "Edit Goals for domain with id: #{@domain.id}"
  needs domains : DomainQuery?
  needs active : String = "Settings"

  def content
    m HeaderComponent, domain: @domain, current_url: "#", domains: domains, total_sum: 1_i64, share_page: false, period_string: "7 days", show_period: false, active: "Goals"
    div class: "max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "Goals", class: "text-xl"
      div class: "my-3 card" do
        if goals.clone.select_count > 0
          render_goals
        else
          text "No goals yet. Let's add one."
        end
      end
      h1 "Add new goal", class: "text-xl"
      div class: "my-3 card" do
        render_goal_form(operation)
      end
    end
  end

  def render_goals
    table class: "table-auto w-full" do
      thead do
        tr do
          th class: "text-left px-2 py-2 text-xs uppercase text-gray-700" do
            text "Action"
          end
          th class: "text-left px-2 py-2 text-xs uppercase text-gray-700" do
            text "Event/path"
          end
          th class: "px-2 py-2 text-left text-xs uppercase text-gray-700" do
            text "Type"
          end
          th class: "px-2 py-2 text-left text-xs uppercase text-gray-700" do
            text "Remove"
          end
        end
      end
      tbody do
        goals.each do |g|
          tr do
            td class: "px-2 py-2 text-s" do
              if g.kind == 0
                text "trigger"
              else
                text "visit"
              end
            end
            td class: "px-2 py-2 text-s" do
              text g.name
            end
            td class: "px-2 py-2 text-s" do
              text Goal::AvramKind.from_value(g.kind).to_s
            end
            td class: "px-2 py-2 text-s" do
              link to: Domains::Settings::Goals::Delete.with(domain_id: @domain.id, goal_id: g.id), class: "block w-auto max-w-full" do
                img src: "/assets/svg/delete.svg", alt: "Delete", class: "h-4 w-4 inline-block w-auto max-w-none"
              end
            end
          end
        end
      end
    end
  end

  def render_goal_form(op)
    form_for Domains::Settings::Goals::Create.with(@domain.id) do
      m IntDropdownComponent, selects: [{"event", 0}, {"path", 1}], field: op.kind

      m Shared::Field, op.name, "Name of event or path to visit", &.text_input(attrs: [:required], autofocus: "true", append_class: "w-full form-input my-2 leading-tight")

      submit "Add", data_disable_with: "Adding...", class: "mt-2 w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end
end
