class Domains::Data::Goals < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/goals" do
    html GoalsPage, domain: domain, goals: get_goals, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end
  
  def get_goals
    goal_metrics = GoalMetrics.new(domain, real_from, real_to, site_path, source, medium, country: country, browser: browser)
    goal_metrics.get_all_goals
  end
end
