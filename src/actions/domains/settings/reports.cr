class Domains::EditReports < DomainBaseAction
  include Hashid
  get "/domins/:domain_id/settings/reports" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    html EditReportsPage,
      operation: UpdateDomain.new(domain, current_user: current_user),
      domain: domain,
      hashid: hashids.encode([domain.id])
  end
end
