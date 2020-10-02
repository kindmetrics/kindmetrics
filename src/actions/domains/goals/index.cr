class Domains::Goals::Index < DomainBaseAction
  include TrialCheck
  get "/domains/:domain_id/goals" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, goals: get_goals, domain: domain, from: real_from, to: real_to, period: period, domains: domains
  end

  def get_goals
    goal_metrics = GoalMetrics.new(domain, real_from, real_to)
    goal_metrics.get_all_goals
  end
end
