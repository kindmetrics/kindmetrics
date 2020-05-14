class Domains::ShowPage < MainLayout
  needs domain : Domain
  quick_def page_title, "Domain with id: #{@domain.id}"

  def content
    link "Back to all Domains", Domains::Index
    h1 "Domain with id: #{@domain.id}"
    render_actions
    render_domain_fields
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
end
