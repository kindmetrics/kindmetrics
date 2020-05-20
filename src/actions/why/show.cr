class Why::Show < BrowserAction
  include Auth::AllowGuests
  get "/why/:slug" do
    page_data = get_page_metadata
    raise "Can't find page" if page_data.nil?

    html Why::ShowPage, slug: slug, path: page_data["file"].as_s, title: page_data["name"].as_s
  end

  private def get_page_metadata
    yaml = File.open("src/marketing/metadata.yml") do |file|
      YAML.parse(file)
    end
    yaml["pages"].as_a.find { |i| i["slug"].as_s == slug }
  end
end
