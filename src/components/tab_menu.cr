class TabMenu < BaseComponent
  needs links : Array(Hash(String, String))
  needs active : String

  def render
    ul class: "flex" do
      links.each do |l|
        if l["name"] == active
          li class: "-mb" do
            a class: "inline-block border-b-2 border-blue-800 py-2 px-4 text-blue-800 font-semibold", href: l["link"].to_s do
              raw l["name"].to_s
            end
          end
        else
          li class: "" do
            a class: "inline-block py-2 px-4 text-gray-800 hover:text-blue-800 font-semibold border-b-2 border-transparent hover:no-underline hover:border-gray-400 transister-menu", href: l["link"].to_s do
              raw l["name"].to_s
            end
          end
        end
      end
    end
  end
end
