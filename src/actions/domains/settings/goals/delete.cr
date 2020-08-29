class Domains::Settings::Goals::Delete < BrowserAction
  delete "/domins/:domain_id/settings/goals/:goal_id" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    goal = GoalQuery.find(goal_id)
    goal.delete
    redirect to: Domains::Settings::EditGoals.with(domain.id)
  end
end
