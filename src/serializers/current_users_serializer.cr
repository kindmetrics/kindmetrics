class CurrentUsersSerializer < BaseSerializer
  def initialize(@current : String)
  end

  def render
    {current: @current}
  end
end
