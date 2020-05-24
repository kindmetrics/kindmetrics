class Domains::Data::Pages < BrowserAction
  param period : String = "7d"

  get "/domains/:domain_id/data/pages" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    html PagesPage, domain: domain, pages: get_pages(domain)
  end

  def get_pages(domain)
    metrics = Metrics.new(domain, period)
    metrics.get_pages
  end
end
