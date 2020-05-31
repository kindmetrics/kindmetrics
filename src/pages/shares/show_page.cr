class Share::ShowPage < MainGuestLayout
  needs domain : Domain
  needs period : String
  needs total_unique : String
  needs total_sum : String
  needs total_bounce : String
  needs period_string : String
  quick_def page_title, @domain.address

  def content
    render_header
    render_total
    div class: "w-full p-5 bg-white rounded-md my-3 mb-6" do
      render_canvas
    end
    render_the_rest
    render_promo if current_user.nil?
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
    div class: "w-full grid grid-flow-col gap-6 mb-4 stats-bg text-white rounded-md p-1 mb-4 " do
      div class: "p-3" do
        para @total_unique.to_s, class: "text-3xl strong"
        para "Unique Visitors", class: "text-sm uppercase"
      end
      div class: "p-3" do
        para @total_sum.to_s, class: "text-3xl strong"
        para "Total Pageviews", class: "text-sm strong uppercase"
      end
      div class: "p-3" do
        para "#{@total_bounce.to_s}%", class: "text-3xl strong"
        para "Bounce rate", class: "text-sm strong uppercase"
      end
    end
  end

  def render_canvas
    render_template "domains/canvas"
  end

  def render_the_rest
    render_template "domains/show"
  end

  def render_header
    render_template "shares/header"
  end

  def render_promo
    render_template "shares/promo"
  end
end
