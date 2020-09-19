class DaysLoaderComponent < BaseComponent
  include DrilldownParams
  needs domain : Domain
  needs period : String

  def render
    params = Hash(String, String).new
    params["data_controller"] = "days-chart"
    params["data_days_chart_period"] = period
    params["data_days_chart_url"] = "/domains/#{@domain.id}/data/days"
    params["height"] = "300"
    params["width"] = "100%"
    params["style"] = "max-height:300px;"
    params["id"] = "days_chart"

    custom_params = set_params("data_days_")
    params.merge!(custom_params) unless custom_params.nil?

    div params do
    end
  end
end
