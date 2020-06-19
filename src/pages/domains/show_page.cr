class Domains::ShowPage < MainGuestLayout
  needs sessions : SessionQuery?
  needs domains : DomainQuery?
  needs domain : Domain
  needs total_unique : Int64
  needs total_sum : Int64
  needs total_bounce : Int64
  needs total_unique_previous : Int64
  needs total_previous : Int64
  needs total_bounce_previous : Int64
  needs period : String
  needs period_string : String
  needs period : String
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
    if share_page?
      render_template "shares/header"
    else
      render_template "domains/header"
    end
  end
end
