class PromoComponent < BaseComponent
  needs domain : Domain

  def render
    div class: "transition-all transform fixed z-100 bottom-0 inset-x-0 pb-2 sm:pb-5" do
      div class: "w-full mx-auto pl-6 pr-8 sm:px-4 md:px-20 md:sb-pl" do
        div class: "p-2 rounded-md stats-bg text-white shadow-lg sm:p-3 flex justify-between items-center" do
          div class: "grid grid-cols-1 lg:grid-cols-2 text-gray-200 flex items-center" do
            span "Kindmetrics Analytics for " + domain.address, class: "text-xl text-white mr-2"
            span "Get exactly the same right now"
          end
          div class: "" do
            link to: SignUps::New, class: "border-white border bg-transparent p-2 text-white inline-block text-sm leading-5 font-medium rounded-md hover:bg-white hover:no-underline hover:text-gray-900" do
              text " Start free trial "
            end
          end
        end
      end
    end
  end
end
