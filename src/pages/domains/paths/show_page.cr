class Domains::Paths::ShowPage < Share::BasePage
  needs path : String
  needs domains : DomainQuery?
  needs referrers : Array(StatsReferrer)
  needs mediums : Array(StatsMediumReferrer)
  needs share_page : Bool = false
  needs unique : Int64
  needs total : Int64
  needs bounce : Int64
  needs unique_previous : Int64
  needs total_previous : Int64
  needs bounce_previous : Int64
  needs period_string : String

  quick_def page_title, "#{@path} at #{@domain.address} last #{period_string}"

  def content
    render_header
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      h1 @path.empty? ? "/" : @path.starts_with?("/") ? @path.to_s : "/" + @path, class: "text-2xl"
      render_total
      div class: "w-full grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row" do
        div class: "card" do
          if @referrers.size > 0
            mount DetailTableComponent.new(first_header: "Referrer", second_header: "Visitors", third_header: "Bounce") do
              @referrers.each_with_index do |event, i|
                mount ReferrerMainComponent.new(event: event, index: i, current_user: current_user, period: @period, current_domain: @domain)
              end
            end
          else
            span class: "text-center block" do
              text "No referrers"
            end
          end
        end
        div class: "card" do
          if @mediums.size > 0
            mount DetailTableComponent.new(first_header: "Medium", second_header: "Visitors", third_header: "Bounce") do
              @mediums.each_with_index do |event, i|
                mount ReferrerMediumComponent.new(event: event, index: i)
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
