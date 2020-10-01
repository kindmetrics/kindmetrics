module Timeparser
  def time_to_string(time : Time) : String
    time.to_s("%Y-%m-%d")
  end

  def string_to_date(date_string : String) : Time
    Time.parse_utc(date_string, "%F")
  end

  def string_to_date(date_string : Time) : Time
    return date_string
  end

  def period_time(period : String) : Time
    case period
    when "30d"
      30.days.ago
    when "1m"
      1.month.ago
    else
      7.days.ago
    end
  end
end
