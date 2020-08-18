class Domains::Data::Pages < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/pages" do
    html PagesPage, domain: domain, pages: get_pages, period: period, site_path: site_path, goal: goal
  end

  def get_pages
    metrics.get_pages
  end
end
