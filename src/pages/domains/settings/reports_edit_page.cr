class Domains::EditReportsPage < AdminLayout
  needs operation : SaveReportUser
  needs domain : Domain
  needs user_list : ReportUserQuery
  needs hashid : String
  needs share_page : Bool = false
  quick_def page_title, "Edit Domain with id: #{@domain.id}"
  needs domains : DomainQuery?
  needs active : String = "Reports"

  def content
    m HeaderComponent, domain: @domain, current_url: "#", domains: domains, total_sum: 1_i64, share_page: false, period_string: "7 days", period: "7d", show_period: false, active: "Reports"
    div class: "max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "Reports", class: "text-xl"
      div class: "my-3 card" do
        if user_list.clone.select_count > 0
          render_user_list
        else
          text "No users to send report to yet. Let's add one."
        end
      end
      h1 "Add new email", class: "text-xl"
      div class: "my-3 card" do
        render_user_email_form(operation)
      end
    end
  end

  def render_user_list
    table class: "table-auto" do
      thead do
        tr do
          th class: "w-1/2 text-left px-2 py-2 text-xs uppercase text-gray-700" do
            raw "Email"
          end
          th class: "w-1/4 px-2 py-2 text-left text-xs uppercase text-gray-700" do
            raw "Weekly"
          end
          th class: "w-1/4 px-2 py-2 text-left text-xs uppercase text-gray-700" do
            raw "Monthly"
          end
          th class: "w-1/4 px-2 py-2 text-left text-xs uppercase text-gray-700" do
            raw "Unsubscribed"
          end
          th class: "w-1/4 px-2 py-2 text-xs uppercase text-gray-700" do
            raw "Delete"
          end
        end
      end
      tbody do
        user_list.each do |ur|
          tr do
            td class: "w-1/2 px-2 py-2" do
              raw ur.email
            end
            td class: "w-1/4 px-2 py-2" do
              if ur.weekly
                img src: "/assets/svg/check.svg", class: "h-4 w-4 inline-block"
              end
            end
            td class: "w-1/4 px-2 py-2" do
              if ur.monthly
                img src: "/assets/svg/check.svg", class: "h-4 w-4 inline-block"
              end
            end
            td class: "w-1/4 px-2 py-2" do
              if ur.unsubscribed
                img src: "/assets/svg/check.svg", class: "h-4 w-4 inline-block"
              end
            end
            td class: "w-1/4 px-2 py-2" do
              unless ur.unsubscribed
                link to: Domains::EmailReport::Delete.with(domain_id: @domain.id, user_report_id: ur.id), class: "block w-auto max-w-full" do
                  img src: "/assets/svg/delete.svg", alt: "Delete", class: "h-4 w-4 inline-block w-auto max-w-none"
                end
              end
            end
          end
        end
      end
    end
  end

  def render_user_email_form(op)
    form_for Domains::EmailReport::Create.with(@domain.id) do
      # Edit fields in src/components/domains/form_fields.cr
      m Shared::Field, op.email, "Email", &.email_input(autofocus: "true", append_class: "w-full form-input my-2 leading-tight")

      div class: "inline-block flex items-center" do
        div class: "w-1/2" do
          m Shared::Field, op.weekly, "Weekly", &.checkbox(append_class: "form-checkbox block clear-both my-4")
        end
        div class: "w-1/2" do
          m Shared::Field, op.monthly, "Monthly", &.checkbox(append_class: "form-checkbox block clear-both my-4")
        end
      end
      submit "Add", data_disable_with: "Adding...", class: "mt-2 w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end
end
