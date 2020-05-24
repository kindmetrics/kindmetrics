class Why::Show < BrowserAction
  include Auth::AllowGuests
  get "/why/:slug" do
    page_data = get_page_metadata
    raise Lucky::RouteNotFoundError.new(context) if page_data.nil?

    markdown = get_markdown(page_data["file"].as_s)

    html Why::ShowPage, slug: slug, data: markdown, title: page_data["name"].as_s
  rescue BakedFileSystem::NoSuchFileError
    raise Lucky::RouteNotFoundError.new(context)
  end

  private def get_page_metadata
    yaml = File.open("src/marketing/metadata.yml") do |file|
      YAML.parse(file)
    end
    yaml["pages"].as_a.find { |i| i["slug"].as_s == slug }
  end

  private def get_markdown(path)
    options = Markd::Options.new(smart: true, safe: true)
    file = FileStorage.get("#{path}")
    Markd.to_html(file.gets_to_end, options)
  end
end
