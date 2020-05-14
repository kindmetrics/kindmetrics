class Domains::EditPage < MainLayout
  needs operation : SaveDomain
  needs domain : Domain
  quick_def page_title, "Edit Domain with id: #{@domain.id}"

  def content
    link "Back to all Domains", Domains::Index
    h1 "Edit Domain with id: #{@domain.id}"
    render_domain_form(@operation)
  end

  def render_domain_form(op)
    form_for Domains::Update.with(@domain.id) do
      # Edit fields in src/components/domains/form_fields.cr
      mount Shared::Field.new(operation.address, "Domain"), &.text_input(autofocus: "true")
      mount Shared::Field.new(operation.time_zone, "Timezone")


      submit "Update", data_disable_with: "Updating..."
    end
  end
end
