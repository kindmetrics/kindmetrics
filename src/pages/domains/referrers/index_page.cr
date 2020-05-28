class Domains::Referrer::IndexPage < MainLayout
  needs domain : Domain
  needs events : Array(StatsReferrer)
  quick_def page_title, "All Domains"

  def content
    h1 "Events for #{domain.address}", class: "text-xl"
    div class: "w-full p-5 shadow-md bg-white rounded my-3 mb-6" do
      events.each do |event|
        render_template "domains/referrers/index_event"
      end
    end
  end
end
