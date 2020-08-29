class DaysSerializer < BaseSerializer
  def initialize(@days : Array(Time) | Nil, @data : Array(Int64 | Nil) | Nil, @pageviews_data : Array(Int64 | Nil) | Nil)
  end

  def render
    if @days.nil?
      {} of String => String
    else
      {labels: @days.not_nil!.map { |d| d.to_s("%d %B") }, data: get_data, pageviews: get_pageviews_data}
    end
  end

  def get_data
    return [] of {y: Int64, x: String} if @days.nil?
    return [] of {y: Int64, x: String} if @data.nil?
    @data.not_nil!.map_with_index do |d, i|
      {
        x: @days.not_nil![i].to_s("%d %B"),
        y: d,
      }
    end
  end

  def get_pageviews_data
    return [] of {y: Int64, x: String} if @days.nil?
    return [] of {y: Int64, x: String} if @pageviews_data.nil?
    @pageviews_data.not_nil!.map_with_index do |d, i|
      {
        x: @days.not_nil![i].to_s("%d %B"),
        y: d,
      }
    end
  end
end
