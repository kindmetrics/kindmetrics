class DifferenceComponent < BaseComponent
  needs now : Int32
  needs before : Int32
  needs reverse : Bool = false

  def render
    div class: "flex items-center ml-4" do
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
    custom_now = now == 0 ? 1 : now
    if up?
      increase = custom_now - before
      ((increase.to_f / before)*100).format(decimal_places: 0, delimiter: "")
    else
      decrease = before - custom_now
      ((decrease.to_f / custom_now)*100).format(decimal_places: 0, delimiter: "")
    end
  end
end
