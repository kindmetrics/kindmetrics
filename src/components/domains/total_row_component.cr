class TotalRowComponent < BaseComponent
  needs total_unique : Int64
  needs total_sum : Int64
  needs total_bounce : Int64
  needs total_unique_previous : Int64
  needs total_previous : Int64
  needs total_bounce_previous : Int64
  needs length : Int64
  needs length_previous : Int64

  def render
    div class: "big_letters" do
      div class: "mt-5 mb-6 grid grid-cols-1 bg-kind-black rounded-md px-2 md:px-0 text-gray-200 overflow-hidden md:grid-cols-4" do
        render_element(@total_unique, @total_unique_previous, normalize_number(@total_unique), normalize_number(@total_unique_previous), "Unique", true)

        render_element(@total_sum, @total_previous, normalize_number(@total_sum), normalize_number(@total_previous), "Pageviews")

        render_element(@total_bounce, @total_bounce_previous, total_bounce.to_s + "% ", total_bounce_previous.to_s + "%", "Bounce rate", false, true)

        render_element(@length, @length_previous, time_format(length), time_format(length_previous), "Average session")
      end
    end
  end

  private def render_element(total, total_previous, format_text, format_previous, name : String, first : Bool = false, reverse : Bool = false)
    div class: "border-b border-gray-200 md:border-b-0 last:border-b-0" do
      div class: "p-4 md:px-8 md:py-4" do
        dl do
          dt class: "text-sm leading-6 font-normal text-gray-200" do
            text name
          end
          dd class: "mt-1 flex items-baseline md:block" do
            div class: "flex items-baseline text-3xl leading-8 mr-2 md:my-2 font-semibold text-white" do
              text format_text
            end
            span class: "mr-2 text-xs leading-5 font-medium text-gray-200" do
              text " from " + format_previous
            end
            mount GrowthComponent, now: total, before: total_previous, reverse: reverse
          end
        end
      end
    end
  end

  private def time_format(seconds : Int64) : String
    time = Time::Span.new(seconds: seconds)
    "#{time.minutes}m #{time.seconds}s"
  end

  private def normalize_number(number : Int64) : String
    number.format
  end
end
