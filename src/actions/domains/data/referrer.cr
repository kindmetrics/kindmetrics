class Domains::Data::Referrer < BrowserAction
  get "/domains/:domain_id/data/referrer" do
    domain = DomainQuery.find(domain_id)
    html ReferrerPage, domain: domain, referrers: get_referrers(domain)
  end

  def get_referrers(domain)
    sql = <<-SQL
    SELECT referrer_domain, COUNT(id) as count FROM events
    WHERE domain_id=#{domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY referrer_domain;
    SQL
    pages = AppDatabase.run do |db|
      db.query_all sql, as: StatsReferrer
    end
    pages.reject! { |r| r.referrer_domain.nil? }
    return pages
  end
end
