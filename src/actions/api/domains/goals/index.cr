class Api::Domains::Goals::Index < ApiDomainBaseAction
  get "/api/domains/:domain_id/goals" do
    json Domain::GoalSerializer.new(get_goals)
  end

  def get_goals
    GoalMetrics.new(domain, real_from, real_to, site_path, source_name, medium_name)
  end
end
