class Domains::Data::Days < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/days" do
    days, today, data = parse_response(domain)
    json DaysSerializer.new(days, today, data)
  end

  def parse_response(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_days
  end
end
