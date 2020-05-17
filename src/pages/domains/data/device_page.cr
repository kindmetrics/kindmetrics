class Domains::Data::Devices::DevicesPage
  include Lucky::HTMLPage
  needs devices : Array(StatsDevice)

  def render
    if devices.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/devices"
    end
  end

end
