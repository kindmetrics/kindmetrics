class Domains::Data::Devices::Device < DomainBaseAction
  get "/domains/:domain_id/data/devices/device" do
    html DevicesPage, domain: domain, devices: get_device(domain)
  end

  def get_device(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_devices
  end
end
