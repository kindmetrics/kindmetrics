class Domains::EditReportsPage < MainLayout
  needs operation : SaveReportUser
  needs domain : Domain
  needs user_list : ReportUserQuery
  needs hashid : String
  quick_def page_title, "Edit Domain with id: #{@domain.id}"

  def content
    render_header
    div class: "mt-10 max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      div class: "my-3 card" do
        h1 "Reports", class: "text-xl"
        render_user_list
      end
      div class: "my-3 card" do
        h1 "Add new email", class: "text-xl"
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
      mount Shared::Field.new(op.email, "Email"), &.email_input(autofocus: "true", append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")

      div class: "inline-block flex items-center" do
        div class: "w-1/2" do
          mount Shared::Field.new(op.weekly, "Weekly"), &.checkbox(append_class: "form-checkbox block clear-both my-4")
        end
        div class: "w-1/2" do
          mount Shared::Field.new(op.monthly, "Monthly"), &.checkbox(append_class: "form-checkbox block clear-both my-4")
        end
      end
      submit "Add", data_disable_with: "Adding...", class: "mt-2 w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def render_header
    div class: "gradient-color" do
      div class: "mt-4 max-w-6xl mx-auto pt-6 px-2 sm:px-0" do
        div class: "flex justify-between items-center" do
          h1 "Domain Settings", class: "text-xl"

          link "Back to dashboard", to: Domains::Show.with(@domain), class: "stats-bg py-3 px-2 text-white hover:bg-gray-700 hover:no-underline rounded transister"
        end
        mount TabMenu.new(links: [{"link" => Domains::Edit.url(@domain), "name" => "Domain"}, {"link" => Domains::EditReports.url(@domain), "name" => "Reports"}, {"link" => Domains::Edit.url(@domain), "name" => "Sharing"}], active: "Reports")
      end
    end
  end

end
