class Faq::DataPrivacyPage < MarketingLayout
  quick_def page_title, "Data privacy"

  def content
    div class: "w-full markdown" do
      raw get_markdown
    end
  end

  def get_markdown
    options = Markd::Options.new(smart: true, safe: true)
    file = FileStorage.get("data_privacy.md")

    Markd.to_html(file.gets_to_end, options)
  end
end
