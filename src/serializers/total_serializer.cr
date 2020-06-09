class TotalSerializer < BaseSerializer
  def initialize(@views : String, @bounce : String, @unique : String)
  end

  def render
    {page_views: @views, bounce: @bounce, unique: @unique}
  end
end
