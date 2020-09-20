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
end
