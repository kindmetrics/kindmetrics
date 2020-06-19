class Domains::Data::PagesPage
  include Lucky::HTMLPage
  needs pages : Array(StatsPages)
  needs domain : Domain

  def render
    if pages.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/pages"
    end
  end
end
