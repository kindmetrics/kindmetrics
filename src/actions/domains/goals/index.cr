class Domains::Goals::Index < DomainBaseAction
  get "/domains/:domain_id/goals" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, goals: get_goals, domain: domain, period: period, domains: domains
  end

  def get_goals
    metrics = Metrics.new(domain, period)
    metrics.get_all_goals
  end
end
