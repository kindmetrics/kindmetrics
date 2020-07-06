class Domains::Referrer::IndexPage < Share::BasePage
  needs events : Array(StatsReferrer)
  quick_def page_title, "Referrers for #{@domain.address}"
  needs share_page : Bool = false
  needs domains : DomainQuery?

  def content
    mount HeaderComponent.new(domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1, share_page: @share_page, period_string: period_string, period: @period, active: "Referrers")
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      sub_header
      div class: "w-full p-5 bg-white rounded-md shadow-md my-3 mb-6" do
        table class: "w-full" do
          thead class:"border-b border-gray-300" do
            tr do
              th class: "text-left uppercase text-gray-600 font-medium text-xs pb-1" do
                raw "Referrer"
              end
              th class: "text-left uppercase text-gray-600 font-medium text-xs pb-1" do
                raw "Bounce"
              end
              th class: "text-left uppercase text-gray-600 font-medium text-xs pb-1" do
                raw "Visitors"
              end
            end
          end
          tbody do
            events.each_with_index do |event, i|
              mount ReferrerMainComponent.new(event: event, index: i, current_user: current_user, period: @period, current_domain: @domain)
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
