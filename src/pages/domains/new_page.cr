class Domains::NewPage < SettingsLayout
  needs operation : SaveDomain
  needs domain : Domain?
  needs domains : DomainQuery?
  quick_def page_title, "New Domain"
  quick_def enable_paddle, false
  quick_def links, [
    {"link" => Users::Edit.url, "name" => "Settings", "icon" => "settings"},
    {"link" => Users::Billing.url, "name" => "Billing", "icon" => "billing"},
  ]
  needs share_page : Bool = false
  needs active : String = ""
  quick_def tab, true

  def content
    div class: "max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "New Domain", class: "text-xl"
      div class: "my-3 card" do
        render_domain_form(@operation)
      end
    end
  end

  def render_domain_form(op)
    form_for Domains::Create do
      # Edit fields in src/components/domains/form_fields.cr
      mount Shared::Field, operation.address, "Host (domain.com)", &.text_input(autofocus: true, append_class: "w-full bg-gray-300 text-gray-900 focus:bg-white focus:text-black rounded p-2 my-2 text-sm leading-tight")
      mount TimezoneDropdown, operation.time_zone
      submit "Save", data_disable_with: "Saving...", class: "w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline mt-2"
    end
  end
end
