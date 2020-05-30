class Domains::Referrer::ShowPage < Domains::BasePage
  needs source : String
  needs events : Array(StatsReferrer)
  needs total : String
  quick_def page_title, "#{source} for #{@domain.address}"

  def content
    render_template "domains/referrers/header"
    div class: "w-full p-5 shadow-md bg-white rounded my-3 mb-6" do
      para "Got #{total} Visitors from #{source} the last #{period_string}", class: "text-xl mb-2"
      events.each do |event|
        render_template "domains/referrers/show_event"
      end
    end
  end

  def sub_header
    h1 source.to_s, class: "text-xl clear-both"
    link "See All referrers", to: Domains::Referrer::Index.with(@domain, period: period), class: "block clear-both"
  end

  def header_url(period)
    Domains::Referrer::Show.with(@domain.id, source: source, period: period)
  end
end
