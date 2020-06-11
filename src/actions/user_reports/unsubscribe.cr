class UserReports::Unsubscribe < BrowserAction
  include Auth::AllowGuests

  get "/reports/unsubscribe/:unsubcribe_token" do
    user_report = ReportUserQuery.new.unsubcribe_token(unsubcribe_token).first
    SaveReportUser.update!(user_report, unsubscribed: true)

    html UnsubscribePage
  end
end
