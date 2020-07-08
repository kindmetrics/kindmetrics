class ReferrerUrlComponent < BaseComponent
  needs event : StatsReferrer
  needs index : Int32

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td class: "w-4/6 p-2" do
        a href: event.referrer_url || "#", class: "block px-2 text-black truncate", style: "margin-top: -26px;", rel: "noreferrer" do
          raw (event.referrer_url || event.referrer_domain || "").to_s
        end
      end
      td class: "w-2/6 p-2" do
        text event.count.to_s
      end
    end
  end
end
