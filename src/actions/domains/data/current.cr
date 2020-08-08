class Domains::Data::Current < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/current" do
    json CurrentUsersSerializer.new(get_current)
  end

  def get_current
    metrics.current_query
  end
end
