class Domains::Data::ReferrerPage
  include Lucky::HTMLPage
  needs domain : Domain
  needs referrers : Array(StatsReferrer)

  def render
    if referrers.empty?
      render_template "domains/data/empty"
    else
      render_template "domains/data/referrer"
    end
  end
end
