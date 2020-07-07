class ReferrerUrlComponent < BaseComponent
  needs domain : String?
  needs visitors : Int64?
  needs index : Int32

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td class: "w-4/6 p-2" do
        a href: domain || "#", class: "block px-2 text-black truncate", style: "margin-top: -26px;", rel: "noreferrer" do
          raw (domain || "").to_s
        end
      end
      td class: "w-2/6 p-2" do
        text visitors.to_s
      end
    end
  end
end
