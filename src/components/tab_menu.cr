class TabMenu < BaseComponent
  needs links : Array(Hash(String, String))
  needs active : String
  needs domain : Domain

  def render
    ul class: "flex hidden md:inline-flex" do
      links.each do |l|
        if l["name"] == active
          li class: "-mb" do
            a class: "inline-block border-b-2 border-white py-2 px-4 text-white hover:no-underline font-semibold", href: l["link"].to_s do
              raw l["name"].to_s
            end
          end
        else
          li class: "" do
            a class: "inline-block py-2 px-4 text-white hover:text-white font-normal border-b-2 border-transparent hover:no-underline hover:border-white transister-menu", href: l["link"].to_s do
              raw l["name"].to_s
            end
          end
        end
      end
    end
    div class: "md:hidden" do
      div class: "relative", data_controller: "dropdown" do
        div class: "inline-block select-none rounded-md p-3 text-md bg-white w-full mb-1", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
          span class: "appearance-none flex items-center justify-between inline-block text-xl" do
            raw active
            raw <<-SVG
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" class="h-4 w-4 ml-2 text-gray-600"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"></path></svg>
            SVG
          end
        end
        div data_target: "dropdown.menu", class: "absolute right-0 mt-2 w-full hidden z-10" do
          div class: "bg-white shadow-lg rounded overflow-hidden border" do
            links.each do |l|
              a l["name"], href: l["link"].to_s, class: "hover:no-underline block px-5 py-4 text-gray-900 bg-white hover:bg-gray-300 whitespace-no-wrap"
            end
          end
        end
      end
    end
  end
end
