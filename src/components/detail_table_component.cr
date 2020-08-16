class DetailTableComponent < BaseComponent
  needs first_header : String
  needs second_header : String
  needs third_header : String?

  def render
    table class: "w-full" do
      thead class: "border-b border-gray-200" do
        tr do
          th class: "text-left uppercase text-gray-600 font-semibold text-xs pb-1" do
            text first_header
          end
          th class: "text-left uppercase text-gray-600 font-semibold text-xs pb-1" do
            text second_header
          end
          unless third_header.nil?
            th class: "text-left uppercase text-gray-600 font-semibold text-xs pb-1" do
              text third_header.not_nil!
            end
          end
        end
      end
      tbody do
        yield
      end
    end
  end
end
