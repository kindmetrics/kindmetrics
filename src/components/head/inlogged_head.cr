class InloggedHead < BaseComponent
  needs current_user : User
  def render
    render_template "components/inlogged_head"
  end
end
