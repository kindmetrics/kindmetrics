class Domains::EditPage < AdminLayout
  needs operation : UpdateDomain
  needs domain : Domain
  needs hashid : String
  quick_def page_title, "Edit Domain with id: #{@domain.id}"
  needs domains : DomainQuery?
  needs share_page : Bool = false
  needs active : String = "Settings"

  def content
    m HeaderComponent, domain: @domain, current_url: "#", domains: domains, total_sum: 1_i64, share_page: false, period_string: "7 days", period: "7d", show_period: false, active: "Settings"
    div class: "max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "Edit #{@domain.address}", class: "text-xl"
      div class: "my-3 card" do
        render_domain_form(@operation)
      end
      render_code_snippet
      delete_domain
      render_share
    end
  end

  def render_domain_form(op)
    form_for Domains::Update.with(@domain.id) do
      # Edit fields in src/components/domains/form_fields.cr
      m Shared::Field, operation.address, "Domain", &.text_input(autofocus: "true", disabled: true, append_class: "w-full form-input my-2 leading-tight transistor")

      m TimezoneDropdown, operation.time_zone

      m Shared::Field, op.shared, "Share", &.checkbox(append_class: "form-checkbox block clear-both my-4")

      submit "Update", data_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def delete_domain
    div class: "my-3 card" do
      h2 "Delete domain", class: "text-xl"
      para "If you want to remove this domain, it will remove all events. It WON'T be able to get the data back if you do so.", class: "py-2 text-sm"
      link "Delete Domain", to: Domains::Delete.with(@domain.id), data_confirm: "Are you sure? All data will be Permantely removed and can't get back", class: "py-2 px-4 bg-red-800 text-white inline-block rounded font-bold", style: "color: white !important"
    end
  end

  def render_code_snippet
    snippet = <<-HTML
    <script src="https://#{KindEnv.env("APP_TRACK_HOST")}/js/kind.js" defer="true" data-domain="#{@domain.address}"></script>
    HTML
    div class: "my-3 card" do
      h2 "The code you use for tracking", class: "text-xl"
      para "Add this to your header", class: "text-sm my-2"
      textarea(snippet, attrs: [:readonly], class: "w-full text-sm form-textarea")
    end
  end

  def render_share
    url = Share::Show.with(hashid).url
    div class: "my-3 card" do
      h2 "Share the analytics", class: "text-xl"
      para "This will be the link you can share with your clients, friends, and more - But don't forget to change the share settings above.", class: "text-sm my-2"
      textarea(url, attrs: [:readonly], class: "w-full text-sm form-input")
    end
  end

  def render_header
    div class: "gradient-color" do
      div class: "mt-4 max-w-6xl mx-auto pt-6 px-2 sm:px-0" do
        div class: "flex justify-between items-center" do
          h1 "Domain Settings", class: "text-xl"

          link "Back to dashboard", to: Domains::Show.with(@domain), class: "stats-bg py-3 px-2 text-white hover:bg-gray-700 hover:no-underline rounded transister"
        end
        m TabMenu, links: [{"link" => Domains::Edit.url(@domain), "name" => "Domain"}, {"link" => Domains::EditReports.url(@domain), "name" => "Reports"}], active: "Domain"
      end
    end
  end
end
