class Domains::Data::Current < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/current" do
    json CurrentUsersSerializer.new(get_current(domain))
  end

  def get_current(domain)
    metrics = Metrics.new(domain, period)
    metrics.current_query
  end
end
