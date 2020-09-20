class UserMonthlyReportEmail < BaseEmail
  to Carbon::Address.new(@user.email)
  subject "Monthly Report for #{@domain.address}"
  templates html

  def initialize(@user : ReportUser, @domain : Domain)
    @metrics = Metrics.new(@domain, 1.months.ago, 1.days.ago)
  end
end
