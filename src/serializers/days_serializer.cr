class DaysSerializer < BaseSerializer
  def initialize(@days : Array(Time) | Nil, @today : Array(Int64 | Nil) | Nil, @data : Array(Int64 | Nil) | Nil, @pageviews_today : Array(Int64 | Nil) | Nil, @pageviews_data : Array(Int64 | Nil) | Nil)
  end

  def render
    if @days.nil?
      {} of String => String
    else
      {labels: @days.not_nil!.map { |d| d.to_s("%d %B") }, today: @today, data: @data, pageviews: @pageviews_data, pageviews_today: @pageviews_today}
    end
  end
end
