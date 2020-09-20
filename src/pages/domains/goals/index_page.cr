class Domains::Goals::IndexPage < Share::BasePage
  needs goals : Array(NamedTuple(goal: Goal, stats_goal: StatsGoal))

  quick_def page_title, "Referrers to #{@domain.address} last #{period_string}"
  needs share_page : Bool = false
  needs domains : DomainQuery?
  needs active : String = "Goals"

  def content
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: @share_page, period_string: period_string, from: from, to: to, active: "Goals"
    div do
      sub_header
      div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-1 gap-6 sm:grid-flow-row" do
        div class: "card" do
          if goals.size > 0
            m DetailTableComponent, first_header: "Goal", second_header: "Conversions" do
              goals.each_with_index do |goal, i|
                m GoalMainComponent, stats_goal: goal[:stats_goal], goal: goal[:goal], index: i, current_user: current_user, from: from, to: to, current_domain: @domain
              end
            end
          else
            span class: "text-center block" do
              text "No goals"
            end
          end
        end
      end
    end
  end

  def sub_header
    div class: "flex justify-between items-center" do
      h1 "Goals for #{domain.address}", class: "text-xl mt-4 mb-4"
      unless share_page?
        link "Goals Settings", to: Domains::Settings::EditGoals.with(domain_id: @domain.id), class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 hover:no-underline rounded w-auto inline-block"
      end
    end
  end

  def header_url(period)
    if share_page?
      Share::Referrer::Index.with(@domain.hashid, from: from, to: to)
    else
      Domains::Goals::Index.with(@domain.id, from: from, to: to)
    end
  end
end
