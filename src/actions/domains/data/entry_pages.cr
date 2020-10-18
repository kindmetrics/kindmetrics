class Domains::Data::EntryPages < DomainPublicBaseAction
  include Auth::AllowGuests
  get "/domains/:domain_id/data/entry_pages" do
    html EntryPagesPage, domain: domain, pages: get_entry_pages, from: real_from, to: real_to, source: source, medium: medium, goal: goal, country: country, browser: browser, site_path: site_path
  end

  def get_entry_pages
    metrics.get_entry_pages
  end
end
