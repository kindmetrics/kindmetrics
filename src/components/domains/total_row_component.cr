class TotalRowComponent < BaseComponent

  needs total_unique : String
  needs total_sum : String
  needs total_bounce : String

  def render
    div class: "big_letters" do
      div class: "max-w-6xl mx-auto py-3 px-2 sm:px-0 grid grid-flow-col gap-6" do
        div class: "p-3" do
          para @total_unique.to_s, class: "text-3xl strong"
          para "Unique Visitors", class: "text-sm uppercase"
        end
        div class: "p-3" do
          para @total_sum.to_s, class: "text-3xl strong"
          para "Total Pageviews", class: "text-sm strong uppercase"
        end
        div class: "p-3" do
          para "#{@total_bounce.to_s}%", class: "text-3xl strong"
          para "Bounce rate", class: "text-sm strong uppercase"
        end
      end
    end
  end
end
