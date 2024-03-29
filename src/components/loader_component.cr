class LoaderComponent < BaseComponent
  include DrilldownParams
  needs domain : Domain
  needs from : String?
  needs to : String?
  needs url : String
  needs style : String = ""

  def render
    params = Hash(String, String).new
    params["data_controller"] = "loader"
    params["data_loader_from"] = from.not_nil! if !from.nil?
    params["data_loader_to"] = to.not_nil! if !to.nil?
    params["data_loader_url"] = "/domains/#{@domain.id}/#{url}"
    params["class"] = style

    custom_params = set_params("data_loader_")
    params.merge!(custom_params) unless custom_params.nil?

    div params do
      div class: "w-20 mx-auto" do
        tag "svg", class: "h-20 w-20 text-kind-black fill-current", id: "loader-1", space: "preserve", version: "1.1", viewBox: "0 0 50 50", x: "0px", xlink: "http://www.w3.org/1999/xlink", xmlns: "http://www.w3.org/2000/svg" do
          tag "path", d: "M25.251,6.461c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615V6.461z" do
            tag "animateTransform", attributeName: "transform", attributeType: "xml", dur: "0.6s", from: "0 25 25", repeatCount: "indefinite", to: "360 25 25", type: "rotate"
          end
        end
      end
    end
  end
end
