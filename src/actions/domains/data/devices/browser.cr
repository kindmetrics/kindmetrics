class Domains::Data::Devices::Browser < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/devices/browser" do
    html BrowsersPage, domain: domain, browsers: get_browsers
  end

  def get_browsers
    metrics.get_browsers
  end
end
