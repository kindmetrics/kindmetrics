class ReferrerEventComponent < BaseComponent
  needs domain : String?
  needs percentage : Float32?

  def render
    div class: "flex items-center justify-between my-1 text-sm" do
      div class: "w-full h-8", style: "max-width: calc(100% - 4rem);" do
        div class: "bg-blue-200 rounded", style: "width: #{(percentage || 0.001)*100};height: 30px"
        a href: domain || "#", class: "block px-2 text-black", style: "margin-top: -26px;" do
          raw (domain || "").to_s
        end
      end
      span do
        raw (((percentage || 0.001)*100).to_i).to_s + "%"
      end
    end
  end
end
