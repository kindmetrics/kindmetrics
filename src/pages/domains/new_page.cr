class Domains::NewPage < MainLayout
  needs operation : SaveDomain
  quick_def page_title, "New Domain"

  def content
    h1 "New Domain"
    render_domain_form(@operation)
  end

  def render_domain_form(op)
    form_for Domains::Create do
      # Edit fields in src/components/domains/form_fields.cr
      mount Shared::Field.new(op.address, "Domain"), &.text_input(autofocus: "true")
      mount Shared::Field.new(op.time_zone, "Timezone")

      submit "Save", data_disable_with: "Saving..."
    end
  end
end
