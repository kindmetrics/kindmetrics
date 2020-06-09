class Domains::Data::Total < DomainPublicBaseAction
  include DomainMetrics
  include Auth::AllowGuests
  get "/domains/:domain_id/data/total" do
    total_views = total_query(domain)
    bounce = bounce_query(domain)
    unique = unique_query(domain)
    json TotalSerializer.new(total_views, bounce, unique)
  end
end
