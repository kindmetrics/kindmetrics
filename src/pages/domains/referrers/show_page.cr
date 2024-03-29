class Domains::Referrer::ShowPage < Share::BasePage
  needs source : String?
  needs events : Array(StatsReferrer)
  needs total : Int64
  needs share_page : Bool = false
  needs domains : DomainQuery?
  needs active : String = "Referrers"

  quick_def page_title, "#{source} for #{@domain.address} last #{period_string}"

  def content
    mount HeaderComponent, domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: @share_page, period_string: period_string, period: period, from: from, to: to, active: "Referrers"
    div do
      sub_header
      div class: "card" do
        para "Got #{pluralize(total, "visitor")} from #{source} the last #{period_string}", class: "text-xl mb-2"
        if @events.size > 0
          mount DetailTableComponent, first_header: "Referrer", second_header: "Visitors" do
            @events.each_with_index do |event, i|
              mount ReferrerUrlComponent, event: event, index: i
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
      Share::Referrer::Show.with(@domain.hashid, source_name: source || "", from: from, to: to)
    else
      Domains::Referrer::Show.with(@domain.id, source_name: source || "", from: from, to: to)
    end
  end
end
