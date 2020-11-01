abstract class MainLayout
  include Lucky::HTMLPage
  include Timeparser

  # 'needs current_user : User' makes it so that the current_user
  # is always required for pages using MainLayout
  needs current_user : User
  needs from : Time
  needs to : Time

  abstract def content
  abstract def page_title
  abstract def enable_paddle

  # MainLayout defines a default 'page_title'.
  #
  # Add a 'page_title' method to your indivual pages to customize each page's
  # title.
  #
  # Or, if you want to require every page to set a title, change the
  # 'page_title' method in this layout to:
  #
  #    abstract def page_title : String
  #
  # This will force pages to define their own 'page_title' method.
  def page_title
    "Welcome"
  end

  def render
    render_template "layouts/main_layout"
  end
end
