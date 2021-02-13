require "../spec_helper"

describe EmailWorker do
  it "Weekly email was delivered" do
    report_user = ReportUserFactory.create
    EmailWorker.send_report("weekly")
    UserWeeklyReportEmail.new(report_user, report_user.domain!).should be_delivered
  end
  it "Monthly email was delivered" do
    report_user = ReportUserFactory.create
    EmailWorker.send_report("monthly")
    UserMonthlyReportEmail.new(report_user, report_user.domain!).should be_delivered
  end
end
