class Domains::Data::Pagespeed < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/pagespeeds" do
    days, data = parse_response
    json PageSpeedSerializer.new(days, data)
  end

  def parse_response
    metrics.get_page_speeds
  end
end
