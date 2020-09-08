class PeriodDropdownComponent < BaseComponent
  needs period_string : String
  needs current_url : String

  def render
    div class: "text-sm leading-none rounded no-underline text-gray-700 hover:text-gray-900" do
      div class: "relative", data_controller: "dropdown" do
        div class: "inline-block select-none rounded-md p-3 text-md border-kind-gray border bg-white transister", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
          span class: "appearance-none flex items-center justify-between inline-block text-lg" do
            span do
              text @period_string
            end
            tag "svg", class: "h-4 w-4 ml-2", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", d: "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            end
          end
        end
        div class: "absolute right-0 mt-2 w-full hidden z-20", data_target: "dropdown.menu" do
          div class: "bg-white shadow-lg rounded overflow-hidden border" do
            a "7 days", href: period_url("7d"), class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-cool-gray-100 whitespace-no-wrap"
            a "14 days", href: period_url("14d"), class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-cool-gray-100 whitespace-no-wrap"
            a "30 days", href: period_url("30d"), class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-cool-gray-100 whitespace-no-wrap"
            a "60 days", href: period_url("60d"), class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-cool-gray-100 whitespace-no-wrap"
            a "90 days", href: period_url("90d"), class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-cool-gray-100 whitespace-no-wrap"
          end
        end
      end
    end
  end

  def period_url(period : String)
    "#{@current_url}?period=#{period}"
  end
end
