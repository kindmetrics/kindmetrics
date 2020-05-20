class Domains::Data::Devices::Os < BrowserAction
  param period : String = "7d"

  get "/domains/:domain_id/data/devices/os" do
    domain = DomainQuery.find(domain_id)
    html OsPage, domain: domain, os: get_os(domain)
  end

  def get_os(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_os
  end
end
