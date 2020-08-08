class Domains::Data::Days < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/days" do
    days, today, data = get_visitors
    pageviews_days, pageviews_today, pageviews_data = get_pageviews
    json DaysSerializer.new(days, today, data, pageviews_today, pageviews_data)
  end

  def get_visitors
    metrics.get_days
  end

  def get_pageviews
    metrics.get_pageviews_days
  end
end
