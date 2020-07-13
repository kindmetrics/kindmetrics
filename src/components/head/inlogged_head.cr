class InloggedHead < BaseComponent
  needs current_user : User?

  def render
    div class: "nav" do
      div class: "max-w-6xl mx-auto py-3 px-2 sm:px-0" do
        div class: "w-full flex justify-between items-center" do
          div class: "flex justify-between items-center" do
            img class: "h-6 w-6 mr-2", src: "/apple-icon-76x76.png"
            link "Kindmetrics", to: Home::Index, class: "text-2xl font-sans hover:underline"
          end
          unless current_user.nil?
            div class: "text-sm leading-none rounded no-underline text-gray-700 hover:text-gray-900" do
              div class: "relative", data_controller: "dropdown" do
                div class: "inline-block select-none rounded-md p-3 text-md bg-white", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
                  span class: "appearance-none flex items-center inline-block text-xl" do
                    text current_user.not_nil!.name || "No name"
                    tag "svg", class: "h-4 w-4 ml-2 text-gray-600", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
                      tag "path", d: "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                    end
                  end
                end
                div class: "absolute right-0 mt-2 w-full z-20 hidden", data_target: "dropdown.menu" do
                  div class: "bg-white shadow-lg rounded overflow-hidden dropdown border" do
                    link "Dashboard", to: Home::Index, class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-gray-300 whitespace-no-wrap"
                    link "Settings", to: Users::Edit, class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-gray-300 whitespace-no-wrap"
                    link "Sign out", to: SignIns::Delete, class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-gray-300 whitespace-no-wrap"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
