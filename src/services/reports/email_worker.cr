class EmailWorker
  def self.send_report(kind : String = "weekly")
    return weekly if kind == "weekly"
    monthly
  end

  def self.weekly
    ReportUserQuery.new.preload_domain.unsubscribed(false).weekly(true).each do |ru|
      UserWeeklyReportEmail.new(ru, ru.domain).deliver
    end
  end

  def self.monthly
    ReportUserQuery.new.preload_domain.unsubscribed(false).monthly(true).each do |ru|
      UserMonthlyReportEmail.new(ru, ru.domain).deliver
    end
  end
end
