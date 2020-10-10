class GrowthComponent < BaseComponent
  needs now : Int64
  needs before : Int64
  needs reverse : Bool = false

  def render
    if reverse?
      if up?
        div class: "inline-flex items-baseline px-2 py-0.5 rounded-full text-xs font-medium leading-5 bg-red-100 text-red-800 md:mt-2 lg:mt-0" do
          tag "svg", class: "-ml-1 mr-0.5 flex-shrink-0 self-center h-4 w-4 text-red-500", fill: "currentColor", viewBox: "0 0 20 20" do
            tag "path", clip_rule: "evenodd", d: "M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z", fill_rule: "evenodd"
          end
          span class: "sr-only" do
            text " Increased by "
          end
          text count_percentage + "%"
        end
      else
        div class: "inline-flex items-baseline px-2 py-0.5 rounded-full text-xs font-medium leading-5 bg-green-100 text-green-800 md:mt-2 lg:mt-0" do
          tag "svg", class: "-ml-1 mr-0.5 flex-shrink-0 self-center h-4 w-4 text-green-500", fill: "currentColor", viewBox: "0 0 20 20" do
            tag "path", clip_rule: "evenodd", d: "M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z", fill_rule: "evenodd"
          end
          span class: "sr-only" do
            text " Decreased by "
          end
          text count_percentage + "%"
        end
      end
    else
      if up?
        div class: "inline-flex items-baseline px-2 py-0.5 rounded-full text-xs font-medium leading-5 bg-green-100 text-green-800 md:mt-2 lg:mt-0" do
          tag "svg", class: "-ml-1 mr-0.5 flex-shrink-0 self-center h-4 w-4 text-green-500", fill: "currentColor", viewBox: "0 0 20 20" do
            tag "path", clip_rule: "evenodd", d: "M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z", fill_rule: "evenodd"
          end
          span class: "sr-only" do
            text " Increased by "
          end
          text count_percentage + "%"
        end
      else
        div class: "inline-flex items-baseline px-2 py-0.5 rounded-full text-xs font-medium leading-5 bg-red-100 text-red-800 md:mt-2 lg:mt-0" do
          tag "svg", class: "-ml-1 mr-0.5 flex-shrink-0 self-center h-4 w-4 text-red-500", fill: "currentColor", viewBox: "0 0 20 20" do
            tag "path", clip_rule: "evenodd", d: "M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z", fill_rule: "evenodd"
          end
          span class: "sr-only" do
            text " Decreased by "
          end
          text count_percentage + "%"
        end
      end
    end
  end

  private def up?
    now > before
  end

  private def count_percentage : String
    custom_now = now == 0 ? 0.1 : now
    custom_before = before == 0 ? 0.1 : before
    if up?
      increase = custom_now - custom_before
      ((increase.to_f / custom_before)*100).format(decimal_places: 0, delimiter: "")
    else
      decrease = custom_before - custom_now
      ((decrease.to_f / custom_now)*100).format(decimal_places: 0, delimiter: "")
    end
  end
end
