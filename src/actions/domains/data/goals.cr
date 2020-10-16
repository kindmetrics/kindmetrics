class Domains::Data::Goals < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/goals" do
    html GoalsPage, domain: domain, goals: get_goals, source_name: source, medium_name: medium, site_path: site_path, from: real_from, to: real_to
  end

  def get_goals
    goal_metrics = GoalMetrics.new(domain, real_from, real_to, site_path, source, medium)
    goal_metrics.get_all_goals
  end
end
