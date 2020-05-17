class Domains::Data::Pages < BrowserAction
  get "/domains/:domain_id/data/pages" do
    domain = DomainQuery.find(domain_id)
    html PagesPage, domain: domain, pages: get_pages(domain)
  end

  def get_pages(domain)
    metrics = Metrics.new(domain)
    metrics.get_pages
  end
end
