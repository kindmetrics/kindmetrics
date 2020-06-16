class Domains::ShowPage < Domains::BasePage
  needs sessions : SessionQuery
  needs domains : DomainQuery
  needs total_unique : String
  needs total_sum : String
  needs total_bounce : String
  needs total_unique_previous : String
  needs total_previous : String
  needs total_bounce_previous : String
  needs period_string : String
  needs share_page : Bool = false
  quick_def page_title, @domain.address

  def content
    render_header
    if total_sum == "0"
      mount AddTrackingComponent.new(domain: @domain)
    else
      render_total
      div class: "max-w-6xl mx-auto py-6 sm:px-6 lg:px-8 p-5 my-3 mb-6 card" do
        render_canvas
      end
      render_the_rest
    end
  end

  def render_total
    mount TotalRowComponent.new(@total_unique, @total_sum, @total_bounce, @total_unique_previous, @total_previous, @total_bounce_previous)
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
