class AddTrackingComponent < BaseComponent
  needs domain : Domain
  def render
    snippet = <<-HTML
    <script src="https://kindmetrics.io/js/track.js" defer="true" data-domain="#{@domain.address}"></script>
    HTML
    div class: "mt-20 max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "Add tracking script", class: "text-xl"
      div class: "my-3 card" do
        para "Add the following code to your <head>:", class: "py-2"
        input(type: "text", value: snippet, name: "script", attrs: [:readonly], class: "w-full border bg-gray-200 text-gray-800 focus:bg-white focus:text-black rounded p-2")
      end
      div class: "my-3 card" do
        para "Waiting to receive first pageview", class: "py-2 w-full inline-block text-center"

        div data_controller: "content-refresh", data_content_refresh_url: "/domains/#{@domain.id}/data/total", data_content_refresh_refresh_interval: "5000"  do

        end
      end
    end
  end
end
