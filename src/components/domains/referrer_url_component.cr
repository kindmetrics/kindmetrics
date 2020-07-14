class ReferrerUrlComponent < BaseComponent
  needs event : StatsReferrer
  needs index : Int32

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td class: "max-w-sm md:max-w-none md:w-4/6 p-2" do
        a href: event.not_nil!.referrer_url || "#", class: "block px-2 text-black truncate", rel: "noreferrer" do
          raw (event.not_nil!.referrer_url || event.not_nil!.referrer_domain || "").to_s
        end
      end
      td class: "w-2/6 p-2" do
        text event.not_nil!.count.to_s
      end
    end
  end
end
