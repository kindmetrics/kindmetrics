class Domains::Data::Goals < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/goals" do
    html GoalsPage, domain: domain, goals: get_goals(domain), period: period
  end

  def get_goals(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_all_goals
  end
end
