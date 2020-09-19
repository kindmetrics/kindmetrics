class Domains::Data::Total < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/total" do
    total_views = metrics.total_query
    bounce = metrics.bounce_query
    unique = metrics.unique_query
    json TotalSerializer.new(total_views, bounce, unique)
  end
end
