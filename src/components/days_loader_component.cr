class DaysLoaderComponent < BaseComponent
  needs domain : Domain
  needs period : String
  needs goal : Goal? = nil

  def render
    if !@goal.nil?
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%", data_days_chart_goal: @goal.not_nil!.id
    else
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%"
    end
  end
end
