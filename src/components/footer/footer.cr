class Footer < BaseComponent
  def render
    div class: "max-w-3xl mx-auto flex justify-between border-t-4 py-12 sm:px-4 mt-12 text-gray-700" do
      div class: "w-2/5 pl-2" do
        para "Kindmetrics", class: "text-xl font-bold"
        para "We love analytics!", class: "text-gray-700"
        para "Devality 2020", class: "text-gray-700"
      end
      div class: "lg:w-1/5 md:w-1/5 sm:w-2/5" do
        span "About", class: "font-bold"
        br
        a "Contact us", class: "text-gray-700", href: "mailto:info@kindmetrics.io"
        br
        a "Documentation", class: "text-gray-700", href: "https://docs.kindmetrics.io"
      end
    end
  end
end
