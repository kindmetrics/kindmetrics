class DomainDropdownComponent < BaseComponent
  needs domain : Domain
  needs domains : DomainQuery?

  def render
    div class: "text-sm leading-none rounded no-underline hover:text-gray-700 bg-menu-button" do
      div class: "relative", data_controller: "dropdown" do
        div class: "inline-block select-none rounded-md p-3 text-md bg-menu-button transister", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
          span class: "appearance-none flex items-center inline-block text-lg" do
            text domain.address
            tag "svg", class: "h-4 w-4 ml-2 text-gray-600", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", d: "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            end
          end
        end
        div class: "absolute right-0 mt-2 w-full hidden z-10", data_target: "dropdown.menu" do
          div class: "bg-white shadow-lg rounded overflow-hidden border" do
            (@domains || [] of Domain).each do |d|
              link d.address, to: Domains::Show.with(d), class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-gray-300 whitespace-no-wrap"
            end
            link "Add Domain", to: Domains::New, class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-gray-300 whitespace-no-wrap"
          end
        end
      end
    end
  end
end
