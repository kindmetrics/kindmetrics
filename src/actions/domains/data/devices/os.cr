class Domains::Data::Devices::Os < DomainPublicBaseAction
  get "/domains/:domain_id/data/devices/os" do
    html OsPage, domain: domain, os: get_os(domain)
  end

  def get_os(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_os
  end
end
