module PeriodPage
  include Lucky::TextHelpers
  include Timeparser

  def period_string
    time_span = to - from
    return "Today" if time_span.days === 0
    pluralize(time_span.days, "days")
  end
end
