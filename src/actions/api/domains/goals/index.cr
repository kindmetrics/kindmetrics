class Api::Domains::Goals::Index < ApiDomainBaseAction
  get "/api/domains/:domain_id/goals" do
    data = get_goals
    if data
      json Domain::GoalSerializer.new(data)
    else
      json nil, status: 500
    end
  end

  def get_goals
    GoalMetrics.new(domain, real_from, real_to, site_path, source_name, medium_name)
  end
end
