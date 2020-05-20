class Why::ShowPage < MarketingLayout
  needs path : String
  needs title : String
  quick_def page_title, @title

  def content
    div class: "w-full markdown" do
      raw get_markdown
    end
  end

  def get_markdown
    Markd.to_html(File.read("src/marketing/#{path}"))
  end
end
