class Domains::Data::Devices::Browser < BrowserAction
  get "/domains/:domain_id/data/devices/browser" do
    domain = DomainQuery.find(domain_id)
    sleep 10
    html BrowsersPage, domain: domain, browsers: get_browser(domain)
  end

  def get_browser(domain)
    sql = <<-SQL
    SELECT browser_name as browser, COUNT(id) as count FROM events
    WHERE domain_id=#{domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY browser_name
    ORDER BY COUNT(id) desc;
    SQL
    browsers = AppDatabase.run do |db|
      db.query_all sql, as: StatsBrowser
    end
    total = browsers.sum { |p| p.count }
    browsers.map! do |p|
      p.percentage = p.count / total.to_f32
      p
    end
    return browsers
  end
end
