class CurrentUsersSerializer < BaseSerializer
  def initialize(@current : Int64)
  end

  def render
    {current: @current}
  end
end
