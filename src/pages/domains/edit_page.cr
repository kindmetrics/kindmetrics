class Domains::EditPage < MainLayout
  needs operation : SaveDomain
  needs domain : Domain
  quick_def page_title, "Edit Domain with id: #{@domain.id}"

  def content
    render_header
    div class: "shadow rounded bg-white p-4" do
      h1 "Edit #{@domain.address}"
      render_domain_form(@operation)
    end
    render_code_snippet
  end

  def render_domain_form(op)
    form_for Domains::Update.with(@domain.id) do
      # Edit fields in src/components/domains/form_fields.cr
      mount Shared::Field.new(operation.address, "Domain"), &.text_input(autofocus: "true", disabled: true, append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
      label_for(operation.time_zone, class: "custom-label")
      select_input(operation.time_zone, class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2") do
        options_for_select(operation.time_zone, TIMEZONES.map {|t| {t, t} })
      end


      submit "Update", data_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def render_code_snippet
    snippet = <<-HTML
    <script src="https://kindmetrics.io/js/track.js" defer="true" data-domain="#{@domain.address}"></script>
    HTML
    div class: "shadow rounded bg-white p-4 mt-4" do
      h2 "The code you use for tracking"
      para "Add this to your header"
      textarea(snippet, attrs: [:readonly], class: "w-full border rounded p-2")
    end
  end

  def render_header
    link "Go back", to: Domains::Show.with(@domain), class: ""
  end
end
