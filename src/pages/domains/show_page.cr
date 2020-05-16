class Domains::ShowPage < MainLayout
  needs domain : Domain
  needs events : EventQuery
  needs total_unique : String
  needs total_sum : String
  quick_def page_title, "Domain with id: #{@domain.id}"

  def content
    link "Back to all Domains", Domains::Index
    h1 @domain.address
    render_actions
    div class: "w-full p-5 shadow-md bg-white rounded my-3" do
      render_total
      render_canvas
    end
    render_the_rest
    render_events
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
    div class: "w-3/5 grid grid-flow-col gap-4 mb-4" do
      div class: "" do
        para @total_unique.to_s, class: "text-2xl strong"
        para "Unique Visitors", class: "text-sm strong"
      end
      div class: "" do
        para @total_sum.to_s, class: "text-2xl strong"
        para "Total Pageviews", class: "text-sm strong"
      end
    end
  end

  def render_canvas
    render_template "domains/canvas"
  end

  def render_the_rest
    render_template "domains/show"
  end

  def render_events
    table class: "w-full" do
      @events.id.desc_order.each do |event|
        tr do
          td do
            text event.created_at.to_s
          end
          td do
            text event.name.to_s
          end
          td do
            text event.user_id.to_s
          end
          td do
            text event.url.to_s
          end
        end
      end
    end
  end
end
