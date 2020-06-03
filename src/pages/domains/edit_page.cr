class Domains::EditPage < MainLayout
  needs operation : UpdateDomain
  needs domain : Domain
  needs hashid : String
  quick_def page_title, "Edit Domain with id: #{@domain.id}"

  def content
    render_header
    div class: "rounded-md bg-white p-4" do
      h1 "Edit #{@domain.address}", class: "text-2xl"
      render_domain_form(@operation)
    end
    render_code_snippet
    render_share
  end

  def render_domain_form(op)
    form_for Domains::Update.with(@domain.id) do
      # Edit fields in src/components/domains/form_fields.cr
      mount Shared::Field.new(operation.address, "Domain"), &.text_input(autofocus: "true", disabled: true, append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
      label_for(operation.time_zone, class: "custom-label")
      select_input(operation.time_zone, class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2") do
        options_for_select(operation.time_zone, TIMEZONES.map { |t| {t, t} })
      end

      mount Shared::Field.new(op.shared, "Share"), &.checkbox(append_class: "form-checkbox block clear-both my-2")

      submit "Update", data_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def render_code_snippet
    snippet = <<-HTML
    <script src="https://kindmetrics.io/js/track.js" defer="true" data-domain="#{@domain.address}"></script>
    HTML
    div class: "rounded-md bg-white p-4 mt-4" do
      h2 "The code you use for tracking"
      para "Add this to your header"
      textarea(snippet, attrs: [:readonly], class: "w-full border rounded p-2")
    end
  end

  def render_share
    url = Share::Show.with(hashid).url
    div class: "rounded-md bg-white p-4 mt-4" do
      h2 "Share the analytics"
      para "This will be the link you can share to your clients, friends and more - But don't forget to change the share settings above."
      textarea(url, attrs: [:readonly], class: "w-full border rounded p-2")
    end
  end

  def render_header
    link "Go back", to: Domains::Show.with(@domain), class: ""
  end
end
