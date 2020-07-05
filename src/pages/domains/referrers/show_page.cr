class Domains::Referrer::ShowPage < Share::BasePage
  needs source : String
  needs events : Array(StatsReferrer)
  needs total : Int64
  needs share_page : Bool = false
  needs domains : DomainQuery?

  quick_def page_title, "#{source} for #{@domain.address}"

  def content
    mount HeaderComponent.new(domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1, share_page: @share_page, period_string: period_string, period: @period, active: "Referrers")
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      sub_header
      div class: "w-full p-5 bg-white rounded-md shadow-md my-3 mb-6" do
        para "Got #{total.to_s} Visitors from #{source} the last #{period_string}", class: "text-xl mb-2"
        events.each do |event|
          mount ReferrerEventComponent.new(domain: event.referrer_domain, real_domain: @domain.address, percentage: event.percentage)
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
