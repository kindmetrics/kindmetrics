class Domains::Paths::ShowPage < Share::BasePage
  needs path : String
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
      render_total
      h2 path, class: "text-2xl"
      div class: "w-full p-5 bg-white rounded-md shadow-md my-3 mb-6" do
        h3 "Referrers", class: "text-2xl"
        referrers.each do |event|
          mount ReferrerEventComponent.new(domain: event.referrer_domain, percentage: event.percentage)
        end
      end
    end
  end

  def render_header
    render_template "domains/paths/header"
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
