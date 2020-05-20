class DaysSerializer < BaseSerializer
  def initialize(@days : Array(Time), @today : Array(Int64 | Nil), @data : Array(Int64 | Nil))
  end

  def render
    {labels: @days.map { |d| d.to_s("%d %B")}, today: @today, data: @data}
  end
end
