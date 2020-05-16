class Domains::Data::Devices::BrowsersPage
  include Lucky::HTMLPage
  needs browsers : Array(StatsBrowser)

  def render
    if browsers.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/browsers"
    end
  end

end
