class Domains::Data::Devices::Os < BrowserAction
  get "/domains/:domain_id/data/devices/os" do
    domain = DomainQuery.find(domain_id)
    html OsPage, domain: domain, os: get_os(domain)
  end

  def get_os(domain)
    sql = <<-SQL
    SELECT operative_system, COUNT(id) as count FROM events
    WHERE domain_id=#{domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY operative_system;
    SQL
    browsers = AppDatabase.run do |db|
      db.query_all sql, as: StatsOS
    end
    total = browsers.sum { |p| p.count }
    browsers.map! do |p|
      p.percentage = p.count / total.to_f32
      p
    end
    return browsers
  end
end
