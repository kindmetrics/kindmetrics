class Domains::EmailReport::Delete < BrowserAction
  delete "/domins/:domain_id/settings/reports/:user_report_id" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    user_report = ReportUserQuery.find(user_report_id)
    user_report.delete
    redirect Domains::EditReports.with(domain.id)
  end
end
