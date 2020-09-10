class CurrentUsersSerializer < BaseSerializer
  include Lucky::TextHelpers
  def initialize(@current : Int64)
  end

  def render
    {current: pluralize(@current, "current active user")}
  end
end
