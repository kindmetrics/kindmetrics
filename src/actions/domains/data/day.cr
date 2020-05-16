class Domains::Data::Days < BrowserAction
  get "/domains/:domain_id/data/days" do
    domain = DomainQuery.find(domain_id)
    days, today, data = parse_response(domain)
    json DaysSerializer.new(days, today, data)
  end

  def parse_response(domain)
    sql = <<-SQL
    SELECT DATE_TRUNC('day', created_at) as date, COUNT(id) as count FROM events
    WHERE domain_id=#{domain.id} AND created_at > '#{30.days.ago}'
    GROUP BY DATE_TRUNC('day', created_at);
    SQL
    grouped = AppDatabase.run do |db|
      db.query_all sql, as: StatsDays
    end
    days = grouped.map { |d| d.date }
    data = grouped.map { |d| d.count }
    today = data.clone
    data.delete_at(data.size-1)
    return days, today, data
  end
end
