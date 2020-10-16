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
    from_string = unless from.nil?
      string_to_date(from.not_nil!)
    end
    to_string = unless to.nil?
      string_to_date(to.not_nil!)
    end
    return if to_string.nil? && from_string.nil?
    GoalMetrics.new(domain, from_string.not_nil!, to_string.not_nil!, site_path, source_name, medium_name)
  end
end
