class TabComponent < BaseComponent
  needs links : Array(Hash(String, String))
  needs active : String

  def render
    div class: "mb-4" do
      div class: "sm:hidden" do
        div class: "text-sm w-full leading-none rounded no-underline hover:text-gray-700" do
          div class: "relative", data_controller: "dropdown" do
            div class: "inline-block select-none rounded-md p-3 text-md transister w-full", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
              span class: "appearance-none flex items-center justify-between inline-block text-lg" do
                span class: "flex items-center" do
                  text active
                end
                tag "svg", class: "h-4 w-4 ml-2 text-gray-600", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
                  tag "path", d: "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                end
              end
            end
            div class: "absolute right-0 mt-2 w-full hidden z-10", data_target: "dropdown.menu" do
              div class: "bg-white shadow-lg rounded overflow-hidden border" do
                links.each do |l|
                  a href: l["link"], class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-menu-button whitespace-no-wrap flex items-center" do
                    text l["name"]
                  end
                end
              end
            end
          end
        end
      end
      div class: "hidden sm:block" do
        div class: "border-b border-gray-200" do
          nav class: "-mb-px flex" do
            links.each do |l|
              classes = if l["name"] == active
                          "border-b-2 border-indigo-500 font-medium text-sm leading-5 text-indigo-600 focus:outline-none focus:text-indigo-800 focus:border-indigo-700"
                        else
                          "hover:text-gray-700 hover:border-gray-300 focus:outline-none focus:text-gray-700 focus:border-gray-300 transister-menu"
                        end
              a href: l["link"], class: "whitespace-no-wrap py-2 px-4 border-b-2 border-transparent font-medium text-sm leading-5 text-gray-500 #{classes}" do
                text l["name"]
              end
            end
          end
        end
      end
    end
  end
end
