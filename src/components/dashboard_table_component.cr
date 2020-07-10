class DashboardTableComponent < BaseComponent
  needs first_header : String
  needs second_header : String
  def render
    table class: "w-full" do
      thead class: "border-b border-gray-300" do
        tr do
          th class: "text-left uppercase text-gray-600 font-medium text-xs pb-1" do
            text first_header
          end
          th class: "text-right uppercase text-gray-600 font-medium text-xs pb-1" do
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
