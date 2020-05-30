class Domains::Countries::IndexPage < Domains::BasePage
  quick_def page_title, "Countries for #{@domain.address}"

  def content
    render_template "domains/countries/header"
    div class: "w-full p-5 shadow-md bg-white rounded my-3 mb-6" do
      render_template "domains/countries/main"
    end
  end

  def sub_header
    h1 "Countries for #{domain.address}", class: "text-xl"
  end

  def header_url(period)
    Domains::Countries::Index.with(@domain.id, period: period)
  end
end
