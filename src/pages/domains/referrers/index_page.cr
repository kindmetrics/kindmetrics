class Domains::Referrer::IndexPage < Share::BasePage
  needs events : Array(StatsReferrer)
  quick_def page_title, "Referrers for #{@domain.address}"
  needs share_page : Bool = false

  def content
    render_template "domains/referrers/header"
    div class: "w-full p-5 bg-white rounded-md my-3 mb-6" do
      events.each do |event|
        render_template "domains/referrers/index_event"
      end
    end
  end

  def sub_header
    h1 "Referrers for #{domain.address}", class: "text-xl"
  end

  def header_url(period)
    if share_page?
      Share::Referrer::Index.with(@domain.hashid, period: period)
    else
      Domains::Referrer::Index.with(@domain.id, period: period)
    end
  end
end
