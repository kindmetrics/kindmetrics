class Domains::Data::Devices::Browser < BrowserAction
  get "/domains/:domain_id/data/devices/browser" do
    domain = DomainQuery.find(domain_id)
    sleep 10
    html BrowsersPage, domain: domain, browsers: get_browser(domain)
  end

  def get_browser(domain)
    metrics = Metrics.new(domain)
    metrics.get_browsers
  end
end
