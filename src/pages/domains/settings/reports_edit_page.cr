class Domains::EditReportsPage < MainLayout
  needs operation : UpdateDomain
  needs domain : Domain
  needs hashid : String
  quick_def page_title, "Edit Domain with id: #{@domain.id}"

  def content
    render_header
    div class: "mt-10 max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      div class: "my-3 card" do
        h1 "Edit #{@domain.address}", class: "text-xl"
      end
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
