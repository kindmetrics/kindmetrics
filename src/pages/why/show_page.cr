class Why::ShowPage < MarketingLayout
  needs data : String
  needs title : String
  quick_def page_title, @title

  def content
    div class: "w-full markdown" do
      raw data
    end
  end
end
