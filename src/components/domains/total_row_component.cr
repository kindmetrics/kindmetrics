class TotalRowComponent < BaseComponent
  needs total_unique : String
  needs total_sum : String
  needs total_bounce : String
  needs total_unique_previous : String
  needs total_previous : String
  needs total_bounce_previous : String

  def render
    div class: "big_letters" do
      div class: "max-w-6xl mx-auto py-3 px-2 sm:px-0 grid grid-flow-col gap-6" do
        div class: "p-3" do
          div class: "text-4xl strong flex items-center" do
            para normalize_number(@total_unique.to_i), class: "text-4xl strong"
            mount DifferenceComponent.new(now: @total_unique.to_i, before: @total_unique_previous.to_i)
          end
          para "Unique", class: "text-sm uppercase font-bold"
        end
        div class: "p-3" do
          div class: "text-4xl strong flex items-center" do
            para normalize_number(@total_sum.to_i), class: "text-4xl strong"
            mount DifferenceComponent.new(now: @total_sum.to_i, before: @total_previous.to_i)
          end
          para "Pageviews", class: "text-sm font-bold uppercase"
        end
        div class: "p-3" do
          div class: "text-4xl strong flex items-center" do
            para "#{@total_bounce.to_s}%", class: "text-4xl strong"
            mount DifferenceComponent.new(now: @total_bounce.to_i, before: @total_bounce_previous.to_i, reverse: true)
          end
          para "Bounce", class: "text-sm font-bold uppercase"
        end
      end
    end
  end

  private def normalize_number(number : Int32) : String
    if number >= 1000
      number.humanize(precision: 2, significant: false)
    else
      number.to_s
    end
  end
end
