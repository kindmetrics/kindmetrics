class Domains::Data::Devices::Device < BrowserAction
  get "/domains/:domain_id/data/devices/device" do
    domain = DomainQuery.find(domain_id)
    html DevicesPage, domain: domain, devices: get_device(domain)
  end

  def get_device(domain)
    metrics = Metrics.new(domain)
    metrics.get_devices
  end
end
