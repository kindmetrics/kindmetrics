class GrowthComponent < BaseComponent
  needs now : Int64
  needs before : Int64
  needs reverse : Bool = false

  def render
    div class: "flex items-center ml-1 md:ml-4" do
      if reverse?
        if up?
          img src: "/assets/svg/arrow-up-red.svg", class: "text-red-800 strong text-xs h-4 w-4 block mr-1"
          span class: "text-red-800 strong text-xs" do
            raw count_percentage + "%"
          end
        else
          img src: "/assets/svg/arrow-down-green.svg", class: "text-green-800 strong text-xs h-4 w-4 block mr-1"
          span class: "text-green-800 strong text-xs" do
            raw count_percentage + "%"
          end
        end
      else
        if up?
          img src: "/assets/svg/arrow-up-green.svg", class: "text-green-800 strong text-xs h-4 w-4 block mr-1"
          span class: "text-green-800 strong text-xs" do
            raw count_percentage + "%"
          end
        else
          img src: "/assets/svg/arrow-down-red.svg", class: "text-red-800 strong text-xs h-4 w-4 block mr-1"
          span class: "text-red-800 strong text-xs" do
            raw count_percentage + "%"
          end
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
