module Period
  include Lucky::TextHelpers
  include Timeparser

  def period_string
    time_span = real_to - real_from
    return "Today" if time_span.days === 0
    pluralize(time_span.days, "days")
  end
end
