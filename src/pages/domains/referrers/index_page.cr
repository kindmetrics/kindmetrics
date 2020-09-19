class Domains::Referrer::IndexPage < Share::BasePage
  needs referrers : Array(StatsReferrer)
  needs mediums : Array(StatsMediumReferrer)
  quick_def page_title, "Referrers to #{@domain.address} last #{period_string}"
  needs share_page : Bool = false
  needs domains : DomainQuery?
  needs active : String = "Referrers"

  def content
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: @share_page, period_string: period_string, period: @period, active: "Referrers"
    div do
      sub_header
      div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row" do
        div class: "card" do
          if referrers.size > 0
            m DetailTableComponent, first_header: "Source", second_header: "Visitors", third_header: "Bounce" do
              referrers.each_with_index do |event, i|
                m ReferrerMainComponent, event: event, index: i, current_user: current_user, period: period, current_domain: domain
              end
            end
          else
            span class: "text-center block" do
              text "No sources"
            end
          end
        end
        div class: "card" do
          if mediums.size > 0
            m DetailTableComponent, first_header: "Medium", second_header: "Visitors", third_header: "Bounce" do
              mediums.each_with_index do |event, i|
                m ReferrerMediumComponent, event: event, index: i, period: period
              end
            end
          else
            span class: "text-center block" do
              text "No mediums"
            end
          end
        end
      end
    end
  end

  def sub_header
    h1 "Referrers for #{domain.address}", class: "text-xl mt-4 mb-4"
  end

  def header_url(period)
    if share_page?
      Share::Referrer::Index.with(@domain.hashid, period: period)
    else
      Domains::Referrer::Index.with(@domain.id, period: period)
    end
  end
end
