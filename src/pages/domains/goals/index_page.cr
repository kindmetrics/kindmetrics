class Domains::Goals::IndexPage < Share::BasePage
  needs goals : Array(Goal)
  quick_def page_title, "Referrers to #{@domain.address} last #{period_string}"
  needs share_page : Bool = false
  needs domains : DomainQuery?

  def content
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1, share_page: @share_page, period_string: period_string, period: @period, active: "Goals"
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      sub_header
      div class: "w-full grid grid-cols-1 md:grid-flow-col md:grid-cols-1 gap-6 sm:grid-flow-row" do
        div class: "card" do
          if goals.size > 0
            m DetailTableComponent, first_header: "Goal", second_header: "Visitors", third_header: "Bounce" do
              goals.each_with_index do |goal, i|
                m GoalMainComponent, goal: goal, index: i, current_user: current_user, period: @period, current_domain: @domain
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
    h1 "Goals for #{domain.address}", class: "text-xl mt-4 mb-4"
  end

  def header_url(period)
    if share_page?
      Share::Referrer::Index.with(@domain.hashid, period: period)
    else
      Domains::Goals::Index.with(@domain.id, period: period)
    end
  end
end
