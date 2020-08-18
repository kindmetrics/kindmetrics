class Domains::Show < DomainBaseAction
  include DomainMetrics
  include Period

  route do
    domains = DomainQuery.new.user_id(current_user.id)
    if current_user.current_domain_id != domain.id
      SaveUser.update!(current_user, current_domain_id: domain.id)
    end
    html ShowPage, domain: domain, goal: goal, site_path: site_path, total_unique: unique_query(domain, goal, site_path), total_unique_previous: unique_query_previous(domain, goal, site_path), total_bounce: bounce_query(domain, goal, site_path), total_bounce_previous: bounce_query_previous(domain, goal, site_path), total_sum: total_query(domain, goal, site_path), total_previous: total_query_previous(domain, goal, site_path), period: period, period_string: period_string, domains: domains
  end
end
