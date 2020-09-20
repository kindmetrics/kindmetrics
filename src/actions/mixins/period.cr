module Period
  include Lucky::TextHelpers
  include Timeparser

  def period_string
    time_span = to_time - from_time
    return "Today" if time_span.days === 0
    pluralize(time_span.days, "days")
  end

  def from_time : Time
    if from.is_a?(String)
      string_to_date(from).as(Time)
    else
      from.as(Time)
    end
  end

  def to_time : Time
    if to.is_a?(String)
      string_to_date(to).as(Time)
    else
      to.as(Time)
    end
  end
end
