class UserWeeklyReportEmail < BaseEmail
  to Carbon::Address.new(@user.email)
  subject "Weekly Report for #{@domain.address}"
  templates html

  def initialize(@user : ReportUser, @domain : Domain)
    @metrics = MetricsNew.new(@domain, 8.days.ago, 1.days.ago, nil, "", "", "")
  end
end
