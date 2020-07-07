class ReferrerUrlComponent < BaseComponent
  needs domain : String?
  needs visitors : Int64?
  needs index : Int32

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td do
        a href: domain || "#", class: "block px-2 text-black truncate", rel: "noreferrer" do
          raw (domain || "").to_s
        end
      end
      td do
        text visitors.to_s
      end
    end
  end
end
