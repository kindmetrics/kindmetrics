class Domains::ShowPage < MainLayout
  needs domain : Domain
  needs events : EventQuery
  needs total_unique : String
  needs total_sum : String
  quick_def page_title, "Domain with id: #{@domain.id}"

  def content
    link "Back to all Domains", Domains::Index
    h1 "Domain with id: #{@domain.id}"
    render_actions
    render_domain_fields
    render_total
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

  def render_domain_fields
    ul do
      li do
        text "address: "
        strong @domain.address.to_s
      end
      li do
        text "time_zone: "
        strong @domain.time_zone.to_s
      end
    end
  end

  def render_total
    div class: "" do
      text @total_unique.to_s
    end
    div class: "" do
      text @total_sum.to_s
    end
  end

  def render_events
    table class: "w-full" do
      @events.each do |event|
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
