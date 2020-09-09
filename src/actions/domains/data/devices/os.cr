class Domains::Data::Devices::Os < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/devices/os" do
    html OsPage, domain: domain, os: get_os
  end

  def get_os
    metrics.get_os
  end
end
