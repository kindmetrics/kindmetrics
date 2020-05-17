class Domains::Data::Days < BrowserAction
  get "/domains/:domain_id/data/days" do
    domain = DomainQuery.find(domain_id)
    days, today, data = parse_response(domain)
    json DaysSerializer.new(days, today, data)
  end

  def parse_response(domain)
    metrics = Metrics.new(domain)
    metrics.get_days
  end
end
