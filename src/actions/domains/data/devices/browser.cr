class Domains::Data::Devices::Browser < DomainBaseAction
  get "/domains/:domain_id/data/devices/browser" do
    html BrowsersPage, domain: domain, browsers: get_browser(domain)
  end

  def get_browser(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_browsers
  end
end
