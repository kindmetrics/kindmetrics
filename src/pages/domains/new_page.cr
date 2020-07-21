class Domains::NewPage < AdminLayout
  needs operation : SaveDomain
  quick_def page_title, "New Domain"

  def content
    div class: "gradient-color" do
      div class: "mt-4 max-w-6xl mx-auto py-6 px-2 sm:px-0 border-t" do
        h1 "New Domain", class: "text-xl"
      end
    end
    div class: "mt-20 max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      div class: "my-3 card" do
        render_domain_form(@operation)
      end
    end
  end

  def render_domain_form(op)
    form_for Domains::Create do
      # Edit fields in src/components/domains/form_fields.cr
      m Shared::Field, operation.address, "Host (domain.com)", &.text_input(autofocus: true, append_class: "w-full bg-gray-300 text-gray-900 focus:bg-white focus:text-black rounded p-2 my-2 text-sm leading-tight")
      m TimezoneDropdown, operation.time_zone
      submit "Save", data_disable_with: "Saving...", class: "w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline mt-2"
    end
  end
end
