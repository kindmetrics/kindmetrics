class Api::Domains::Goals::Index < ApiDomainBaseAction
  get "/api/domains/:domain_id/goals" do
    json Domain::GoalSerializer.new(get_goals)
  end

  def get_goals
    GoalMetrics.new(domain, string_to_date(from), string_to_date(to), site_path, source_name, medium_name)
  end
end
