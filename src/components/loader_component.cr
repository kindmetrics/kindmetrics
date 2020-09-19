class LoaderComponent < BaseComponent
  include DrilldownParams
  needs domain : Domain
  needs period : String
  needs url : String
  needs style : String = ""

  def render
    params = Hash(String, String).new
    params["data_controller"] = "loader"
    params["data_loader_period"] = period
    params["data_loader_url"] = "/domains/#{@domain.id}/#{url}"
    params["class"] = style

    custom_params = set_params("data_loader_")
    params.merge!(custom_params) unless custom_params.nil?

    div params do
    end
  end
end
