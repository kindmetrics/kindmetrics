class Domains::PageSpeeds::IndexPage < Share::BasePage
  quick_def page_title, "Page speed for #{@domain.address} last #{period_string}"
  needs share_page : Bool = false
  needs domains : DomainQuery?
  needs active : String = "Page Speeds"
  needs goal : Goal?
  needs site_path : String?
  needs source : String?
  needs medium : String?
  needs browser : String?
  needs country : String?

  def content
    mount HeaderComponent, domain: domain, current_url: context.request.path, domains: domains, total_sum: 1_i64, share_page: share_page?, period_string: period_string, current_user: current_user, period: period, from: from, to: to, active: "Page Speeds"
    div do
      sub_header
      div class: "card" do
        mount PageSpeedLoaderComponent, domain: domain, from: time_to_string(from), to: time_to_string(to)
      end
      render_grid
    end
  end

  def render_grid
    div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row mt-6" do
      div class: "card" do
        mount LoaderComponent, domain: domain, url: "data/pagespeeds/path", goal: goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, style: "relative clear-both", source: source, medium: medium, country: country, browser: browser
      end
      div class: "card" do
        mount LoaderComponent, domain: domain, url: "data/pagespeeds/countries", goal: goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, style: "relative clear-both", source: source, medium: medium, country: country, browser: browser
      end
    end
  end

  def sub_header
    h1 "Page Speed for #{domain.address}", class: "text-xl"
  end

  def header_url(period)
    if share_page?
      Share::PageSpeeds::Index.with(domain.hashid, from: time_to_string(from), to: time_to_string(to))
    else
      Domains::PageSpeeds::Index.with(domain.id, from: time_to_string(from), to: time_to_string(to))
    end
  end
end
