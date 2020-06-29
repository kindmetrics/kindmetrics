class Domains::Countries::IndexPage < Share::BasePage
  quick_def page_title, "Countries for #{@domain.address}"
  needs share_page : Bool = false
  needs domains : DomainQuery?

  def content
    mount HeaderComponent.new(domain: @domain, current_url: context.request.path, domains: domains, total_sum: 1, share_page: @share_page, period_string: period_string, period: @period, active: "Countries")
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6 mt-8" do
      sub_header
      div class: "w-full p-5 bg-white rounded-md shadow-md my-3 mb-6" do
        render_template "domains/countries/main"
      end
    end
  end

  def sub_header
    h1 "Countries for #{domain.address}", class: "text-xl"
  end

  def header_url(period)
    if share_page?
      Share::Countries::Index.with(@domain.hashid, period: period)
    else
      Domains::Countries::Index.with(@domain.id, period: period)
    end
  end
end
