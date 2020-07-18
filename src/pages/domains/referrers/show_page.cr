class Domains::Referrer::ShowPage < Share::BasePage
  needs source : String
  needs events : Array(StatsReferrer)
  needs total : Int64
  needs share_page : Bool = false
  needs domains : DomainQuery?

  quick_def page_title, "#{source} for #{@domain.address} last #{period_string}"

  def content
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: @share_page, period_string: period_string, period: @period, active: "Referrers"
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      sub_header
      div class: "w-full p-5 bg-white rounded-md shadow-md my-3 mb-6" do
        para "Got #{pluralize(total, "visitor")} from #{source} the last #{period_string}", class: "text-xl mb-2"
        if @events.size > 0
          m DetailTableComponent,first_header: "Referrer", second_header: "Visitors" do
            @events.each_with_index do |event, i|
              m ReferrerUrlComponent, event: event, index: i
            end
          end
        else
          span class: "text-center block" do
            text "No referrers"
          end
        end
      end
    end
  end

  def sub_header
    h1 source.to_s, class: "text-xl clear-both"
  end

  def header_url(period)
    if share_page?
      Share::Referrer::Show.with(@domain.hashid, source: source, period: period)
    else
      Domains::Referrer::Show.with(@domain.id, source: source, period: period)
    end
  end
end
