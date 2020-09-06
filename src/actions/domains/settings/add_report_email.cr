class Domains::EmailReport::Create < BrowserAction
  include TrialCheck
  post "/domins/:domain_id/settings/reports" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    SaveReportUser.create(params, domain_id: domain.id, unsubscribed: false) do |_operation, report_user|
      flash.keep
      if report_user
        flash.success = "The record has been saved"
        redirect to: Domains::EditReports.with(domain.id)
      else
        flash.failure = "It looks like the form is not valid"
        redirect to: Domains::EditReports.with(domain.id)
      end
    end
  end
end
