class Domains::Data::Goals < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/goals" do
    html GoalsPage, domain: domain, goals: get_goals, source_name: source_name, medium_name: medium_name, site_path: site_path, from: string_to_date(from), to: string_to_date(to)
  end

  def get_goals
    metrics.get_all_goals
  end
end
