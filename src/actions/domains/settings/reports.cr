class Domains::EditReports < DomainBaseAction
  include Hashid
  get "/domins/:domain_id/settings/reports" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    user_list = ReportUserQuery.new.domain_id(domain.id)
    html EditReportsPage,
      operation: SaveReportUser.new(domain_id: domain.id),
      domain: domain,
      hashid: hashids.encode([domain.id]),
      user_list: user_list
  end
end
