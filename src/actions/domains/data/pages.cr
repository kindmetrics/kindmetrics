class Domains::Data::Pages < BrowserAction
  get "/domains/:domain_id/data/pages" do
    domain = DomainQuery.find(domain_id)
    html PagesPage, domain: domain, pages: get_pages(domain)
  end

  def get_pages(domain)
    sql = <<-SQL
    SELECT path as address, COUNT(id) as count FROM events
    WHERE domain_id=#{domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY path;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsPages
    end
    total = pages.sum { |p| p.count }
    pages.map! do |p|
      p.percentage = p.count / total.to_f32
      p
    end
    return pages
  end
end
