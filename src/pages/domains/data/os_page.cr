class Domains::Data::Devices::OsPage
  include Lucky::HTMLPage
  needs os : Array(StatsOS)

  def render
    if os.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/os"
    end
  end

end
