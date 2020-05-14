class Domains::IndexPage < MainLayout
  needs domains : DomainQuery
  quick_def page_title, "All Domains"

  def content
    h1 "All Domains"
    link "New Domain", to: Domains::New
    render_domains
  end

  def render_domains
    ul do
      @domains.each do |domain|
        li do
          link domain.address, Domains::Show.with(domain)
        end
      end
    end
  end
end
