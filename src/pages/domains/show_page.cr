class Domains::ShowPage < Domains::BasePage
  needs sessions : SessionQuery
  needs domains : DomainQuery
  needs total_unique : String
  needs total_sum : String
  needs total_bounce : String
  needs period_string : String
  needs share_page : Bool = false
  quick_def page_title, @domain.address

  def content
    render_header
    render_total
    div class: "max-w-6xl mx-auto py-6 sm:px-6 lg:px-8 p-5 my-3 mb-6 card" do
      render_canvas
    end
    render_the_rest
  end

  def render_actions
    section do
      link "Edit", Domains::Edit.with(@domain.id)
      text " | "
      link "Delete",
        Domains::Delete.with(@domain.id),
        data_confirm: "Are you sure?"
    end
  end

  def render_total
    mount TotalRowComponent.new(@total_unique, @total_sum, @total_bounce)
  end

  def render_canvas
    render_template "domains/canvas"
  end

  def render_the_rest
    render_template "domains/show"
  end

  def render_header
    render_template "domains/header"
  end
end
