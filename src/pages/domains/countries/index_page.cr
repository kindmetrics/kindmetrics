class Domains::Countries::IndexPage < Share::BasePage
  quick_def page_title, "Countries for #{@domain.address}"
  needs share_page : Bool = false

  def content
    render_template "domains/countries/header"
    div class: "w-full p-5 bg-white rounded-md my-3 mb-6" do
      render_template "domains/countries/main"
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
