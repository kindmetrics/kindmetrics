class Domains::Data::Pages < DomainBaseAction
  get "/domains/:domain_id/data/pages" do
    html PagesPage, domain: domain, pages: get_pages(domain)
  end

  def get_pages(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_pages
  end
end
