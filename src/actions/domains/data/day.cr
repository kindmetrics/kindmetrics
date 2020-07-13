class Domains::Data::Days < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/days" do
    days, today, data = get_visitors(domain)
    pageviews_days, pageviews_today, pageviews_data = get_pageviews(domain)
    json DaysSerializer.new(days, today, data, pageviews_today, pageviews_data)
  end

  def get_visitors(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_days
  end

  def get_pageviews(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_pageviews_days
  end
end
