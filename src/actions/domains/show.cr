class Domains::Show < DomainBaseAction
  include Period
  include TrialCheck
  include PreviousDomainMetrics

  route do
    domains = DomainQuery.new.user_id(current_user.id)
    if current_user.current_domain_id != domain.id
      SaveUser.update!(current_user, current_domain_id: domain.id)
    end

    html ShowPage, domain: domain, goal: goal, site_path: site_path, source: source_name, medium: medium_name, total_unique: metrics.unique_query, total_unique_previous: previous_metric.unique_query, total_bounce: metrics.bounce_query, total_bounce_previous: previous_metric.bounce_query, total_sum: metrics.total_query, total_previous: previous_metric.total_query, period: period, period_string: period_string, domains: domains
  end
end
