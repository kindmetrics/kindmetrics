class ReferrerMediumComponent < BaseComponent
  needs event : StatsMediumReferrer
  needs index : Int32

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td class: "w-4/6 p-2" do
        text event.referrer_medium.to_s
      end
      td class: "w-1/6 p-2" do
        text event.count.to_s
      end
      td class: "w-1/6 p-2" do
        text event.bounce_rate.to_s + "%"
      end
    end
  end
end
