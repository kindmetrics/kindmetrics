class DaysSerializer < BaseSerializer
  def initialize(@days : Array(Time), @today : Array(Int64), @data : Array(Int64))
  end

  def render
    {labels: @days, today: @today, data: @data}
  end
end
