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
    div class: "big_letters gradient-color" do
      div class: "mt-5 grid grid-cols-1 rounded-md overflow-hidden md:grid-cols-4" do
        render_element(@total_unique, @total_unique_previous, normalize_number(@total_unique), normalize_number(@total_unique_previous), "Unique", true)

        render_element(@total_sum, @total_previous, normalize_number(@total_sum), normalize_number(@total_previous), "Pageviews")

        render_element(@total_bounce, @total_bounce_previous, total_bounce.to_s + "% ", total_bounce_previous.to_s + "%", "Bounce rate")

        render_element(@length, @length_previous, time_format(length), time_format(length_previous), "Average session")
      end
    end
  end

  private def render_element(total, total_previous, format_text, format_previous, name : String, first : Bool = false)
    div class: "border-t border-kind-gray md:border-0 #{!first ? "md:border-l" : nil}" do
      div class: "px-2 py-3 sm:p-4" do
        dl do
          dt class: "text-sm leading-6 font-normal text-gray-900" do
            text name
          end
          dd class: "mt-1 flex items-baseline md:block" do
            div class: "flex items-baseline text-3xl leading-8 mr-2 font-semibold text-kind-blue" do
              text format_text
            end
            span class: "mr-2 text-sm leading-5 font-medium text-gray-500" do
              text " from " + format_previous
            end
            m GrowthComponent, now: total, before: total_previous
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
