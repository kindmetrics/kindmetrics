class Domains::Show < DomainBaseAction
  include DomainMetrics
  include Period

  route do
    domains = DomainQuery.new.user_id(current_user.id)
    if current_user.current_domain_id != domain.id
      SaveUser.update!(current_user, current_domain_id: domain.id)
    end
    html ShowPage, domain: domain, total_unique: unique_query(domain), total_unique_previous: unique_query_previous(domain), total_bounce: bounce_query(domain), total_bounce_previous: bounce_query_previous(domain), total_sum: total_query(domain), total_previous: total_query_previous(domain), period: period, period_string: period_string, sessions: SessionQuery.new.domain_id(domain_id), domains: domains
  end
end
