class TotalRowComponent < BaseComponent
  needs total_unique : Int64
  needs total_sum : Int64
  needs total_bounce : Int64
  needs total_unique_previous : Int64
  needs total_previous : Int64
  needs total_bounce_previous : Int64

  def render
    div class: "big_letters gradient-color" do
      div class: "mt-5 grid grid-cols-1 rounded-md overflow-hidden md:grid-cols-3" do
        div do
          div class: "px-4 py-5 sm:p-6" do
            dl do
              dt class: "text-base leading-6 font-normal text-gray-900" do
                text " Unique "
              end
              dd class: "mt-1 flex items-baseline md:block lg:flex" do
                div class: "flex items-baseline text-3xl leading-8 mr-2 font-semibold blue-numbers" do
                  text normalize_number(@total_unique)
                  span class: "ml-2 text-sm leading-5 font-medium text-gray-500" do
                    text " from " + normalize_number(@total_unique_previous)
                  end
                end
                m GrowthComponent, now: @total_unique, before: @total_unique_previous
              end
            end
          end
        end

        div class: "border-t border-gray-200 md:border-0 md:border-l" do
          div class: "px-4 py-5 sm:p-6" do
            dl do
              dt class: "text-base leading-6 font-normal text-gray-900" do
                text " Pageviews "
              end
              dd class: "mt-1 flex items-baseline md:block lg:flex" do
                div class: "flex items-baseline text-3xl leading-8 mr-2 font-semibold blue-numbers" do
                  text normalize_number(@total_sum)
                  span class: "ml-2 text-sm leading-5 font-medium text-gray-500" do
                    text " from " + normalize_number(@total_previous)
                  end
                end
                m GrowthComponent, now: @total_sum, before: @total_previous
              end
            end
          end
        end

        div class: "border-t border-gray-200 md:border-0 md:border-l" do
          div class: "px-4 py-5 sm:p-6" do
            dl do
              dt class: "text-base leading-6 font-normal text-gray-900" do
                text " Bounce rate "
              end
              dd class: "mt-1 flex items-baseline md:block lg:flex" do
                div class: "flex items-baseline text-3xl leading-8 mr-2 font-semibold blue-numbers" do
                  text total_bounce.to_s + "% "
                  span class: "ml-2 text-sm leading-5 font-medium text-gray-500" do
                    text " from " + total_bounce_previous.to_s + "%"
                  end
                end
                m GrowthComponent, now: @total_bounce, before: @total_bounce_previous, reverse: true
              end
            end
          end
        end
      end
    end
  end

  private def normalize_number(number : Int64) : String
    number.format
  end
end
