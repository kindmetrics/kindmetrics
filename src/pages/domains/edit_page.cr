class Domains::EditPage < MainLayout
  needs operation : UpdateDomain
  needs domain : Domain
  needs hashid : String
  quick_def page_title, "Edit Domain with id: #{@domain.id}"

  def content
    div class: "mt-20 max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      render_header
      div class: "my-3 card" do
        h1 "Edit #{@domain.address}", class: "text-xl"
        render_domain_form(@operation)
      end
      render_code_snippet
      render_share
    end
  end

  def render_domain_form(op)
    form_for Domains::Update.with(@domain.id) do
      # Edit fields in src/components/domains/form_fields.cr
      mount Shared::Field.new(operation.address, "Domain"), &.text_input(autofocus: "true", disabled: true, append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")

      mount TimezoneDropdown.new(operation.time_zone)

      mount Shared::Field.new(op.shared, "Share"), &.checkbox(append_class: "form-checkbox block clear-both my-4")

      submit "Update", data_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def render_code_snippet
    snippet = <<-HTML
    <script src="https://kindmetrics.io/js/track.js" defer="true" data-domain="#{@domain.address}"></script>
    HTML
    div class: "my-3 card" do
      h2 "The code you use for tracking", class: "text-xl"
      para "Add this to your header", class: "text-sm my-2"
      textarea(snippet, attrs: [:readonly], class: "w-full text-sm rounded p-2 text-gray-900 border border-gray-400 hover:border hover:border-blue-500")
    end
  end

  def render_share
    url = Share::Show.with(hashid).url
    div class: "my-3 card" do
      h2 "Share the analytics", class: "text-xl"
      para "This will be the link you can share to your clients, friends and more - But don't forget to change the share settings above.", class: "text-sm my-2"
      textarea(url, attrs: [:readonly], class: "w-full text-sm rounded p-2 text-gray-900 border border-gray-400 hover:border hover:border-blue-500")
    end
  end

  def render_header
    link "Go back", to: Domains::Show.with(@domain), class: ""
  end
end
