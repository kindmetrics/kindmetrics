class Domains::Paths::ShowPage < Share::BasePage
  needs path : String
  needs domains : DomainQuery?
  needs referrers : Array(StatsReferrer)
  needs share_page : Bool = false
  needs unique : Int64
  needs total : Int64
  needs bounce : Int64
  needs unique_previous : Int64
  needs total_previous : Int64
  needs bounce_previous : Int64
  needs period_string : String

  quick_def page_title, "#{path} for #{@domain.address}"

  def content
    render_header
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      h1 @path.empty? ? "/" : @path, class: "text-2xl"
      render_total
      div class: "w-full p-5 bg-white rounded-md shadow-md my-3 mb-6" do
        h2 "Top Referrer", class: "text-xl"
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
            @referrers.each_with_index do |event, i|
              mount ReferrerMainComponent.new(event: event, index: i, current_user: current_user, period: @period, current_domain: @domain)
            end
          end
        end
      end
    end
  end

  def render_header
    mount HeaderComponent.new(domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1, share_page: @share_page, period_string: period_string, period: @period, active: "Dashboard")
  end

  def sub_header
    h1 path.to_s, class: "text-xl clear-both"
  end

  def render_total
    mount TotalRowComponent.new(@unique, @total, @bounce, @unique_previous, @total_previous, @bounce_previous)
  end

  def header_url(period)
    if share_page?
      Share::Referrer::Show.with(@domain.hashid, source: source, period: period)
    else
      Domains::Referrer::Show.with(@domain.id, source: source, period: period)
    end
  end
end
