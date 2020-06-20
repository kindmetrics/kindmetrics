class Domains::Data::PagesPage
  include Lucky::HTMLPage
  needs pages : Array(StatsPages)
  needs period : String
  needs domain : Domain
  needs current_user : User?

  def render
    if pages.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/pages"
    end
  end
end
