class Domains::Data::Devices::Browser < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/devices/browser" do
    html BrowsersPage, domain: domain, browsers: get_browsers, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end

  def get_browsers
    metrics.get_browsers
  end
end
