class TotalRowComponent < BaseComponent
  needs total_unique : Int64
  needs total_sum : Int64
  needs total_bounce : Int64
  needs total_unique_previous : Int64
  needs total_previous : Int64
  needs total_bounce_previous : Int64

  def render
    div class: "big_letters" do
      div class: "max-w-6xl mx-auto py-3 px-2 sm:px-0 grid grid-flow-col gap-6" do
        div class: "p-3" do
          div class: "text-4xl strong md:flex items-center" do
            para normalize_number(@total_unique), class: "text-4xl strong"
            m GrowthComponent.new(now: @total_unique, before: @total_unique_previous)
          end
          para "Unique", class: "text-sm uppercase font-bold"
        end
        div class: "p-3" do
          div class: "text-4xl strong md:flex items-center" do
            para normalize_number(@total_sum), class: "text-4xl strong"
            m GrowthComponent.new(now: @total_sum, before: @total_previous)
          end
          para "Pageviews", class: "text-sm font-bold uppercase"
        end
        div class: "p-3" do
          div class: "text-4xl strong md:flex items-center" do
            para "#{@total_bounce.to_s}%", class: "text-4xl strong"
            m GrowthComponent.new(now: @total_bounce, before: @total_bounce_previous, reverse: true)
          end
          para "Bounce", class: "text-sm font-bold uppercase"
        end
      end
    end
  end

  private def normalize_number(number : Int64) : String
    if number >= 1000
      number.humanize(precision: 2, significant: false)
    else
      number.to_s
    end
  end
end
