class SiteHead < BaseComponent
  needs current_user : User?

  def render
    render_template "components/head"
  end
end
