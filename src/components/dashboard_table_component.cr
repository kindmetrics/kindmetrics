class DashboardTableComponent < BaseComponent
  needs first_header : String
  needs second_header : String

  def render
    table class: "w-full mb-3" do
      thead class: "border-b border-gray-200" do
        tr do
          th class: "text-left uppercase text-gray-600 font-semibold text-xs pb-1" do
            text first_header
          end
          th class: "text-right uppercase text-gray-600 font-semibold text-xs pb-1" do
            text second_header
          end
        end
      end
      tbody do
        yield
      end
    end
  end
end
