class Home::IndexPage < MarketingLayout
  quick_def page_title, "Simple Privacy Analytics"

  def content
    render_template "home/start_page"
  end
end
