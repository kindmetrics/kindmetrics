class Domains::Goals::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/goals" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, goals: get_goals, domain: domain, from: string_to_date(from), to: string_to_date(to), domains: domains
  end

  def get_goals
    goal_metrics = GoalMetrics.new(domain, string_to_date(from), string_to_date(to))
    goal_metrics.get_all_goals
  end
end
