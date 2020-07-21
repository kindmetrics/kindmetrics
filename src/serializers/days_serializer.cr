class DaysSerializer < BaseSerializer
  def initialize(@days : Array(Time) | Nil, @today : Array(Int64 | Nil) | Nil, @data : Array(Int64 | Nil) | Nil, @pageviews_today : Array(Int64 | Nil) | Nil, @pageviews_data : Array(Int64 | Nil) | Nil)
  end

  def render
    if @days.nil?
      {} of String => String
    else
      {labels: @days.not_nil!.map { |d| d.to_s("%d %B") }, today: get_today, data: get_data, pageviews: get_pageviews_data, pageviews_today: get_pageviews_today}
    end
  end

  def get_data
    return [] of {y: Int64, x: String} if @days.nil?
    return [] of {y: Int64, x: String} if @data.nil?
    data = @data.not_nil!.map_with_index do |d, i|
      {
        x: @days.not_nil![i].to_s("%d %B"),
        y: d,
      }
    end
    data << {x: @days.not_nil!.last.to_s("%d %B"), y: nil}
    data
  end

  def get_today
    return [] of {y: Int64, x: String} if @days.nil?
    return [] of {y: Int64, x: String} if @today.nil?
    @today.not_nil!.map_with_index do |d, i|
      {
        x: @days.not_nil![i].to_s("%d %B"),
        y: d,
      }
    end
  end

  def get_pageviews_data
    return [] of {y: Int64, x: String} if @days.nil?
    return [] of {y: Int64, x: String} if @pageviews_data.nil?
    pageviews = @pageviews_data.not_nil!.map_with_index do |d, i|
      {
        x: @days.not_nil![i].to_s("%d %B"),
        y: d,
      }
    end
    pageviews << {x: @days.not_nil!.last.to_s("%d %B"), y: nil}
    pageviews
  end

  def get_pageviews_today
    return [] of {y: Int64, x: String} if @days.nil?
    return [] of {y: Int64, x: String} if @pageviews_today.nil?
    @pageviews_today.not_nil!.map_with_index do |d, i|
      {
        x: @days.not_nil![i].to_s("%d %B"),
        y: d,
      }
    end
  end
end
