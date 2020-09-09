class Domains::Data::Devices::Device < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/devices/device" do
    html DevicesPage, domain: domain, devices: get_devices
  end

  def get_devices
    metrics.get_devices
  end
end
