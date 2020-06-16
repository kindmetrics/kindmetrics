class TotalSerializer < BaseSerializer
  def initialize(@views : Int64, @bounce : Int64, @unique : Int64)
  end

  def render
    {page_views: @views.to_s, bounce: @bounce.to_s, unique: @unique.to_s}
  end
end
