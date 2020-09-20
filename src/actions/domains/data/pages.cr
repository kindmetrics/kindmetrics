class Domains::Data::Pages < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/pages" do
    html PagesPage, domain: domain, pages: get_pages, from: string_to_date(from), to: string_to_date(to), source_name: source_name, medium_name: medium_name, goal: goal, site_path: site_path
  end

  def get_pages
    metrics.get_pages
  end
end
