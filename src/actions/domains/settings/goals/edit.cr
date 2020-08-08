class Domains::Settings::EditGoals < DomainBaseAction
  include Hashid
  get "/domins/:domain_id/settings/goals" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    domains = DomainQuery.new.user_id(current_user.id)
    goals = GoalQuery.new.domain_id(domain.id)
    html EditGoalsPage,
      operation: SaveGoal.new(domain_id: domain.id),
      domain: domain,
      hashid: hashids.encode([domain.id]),
      goals: goals,
      domains: domains
  end
end
