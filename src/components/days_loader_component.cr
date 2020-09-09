class DaysLoaderComponent < BaseComponent
  needs domain : Domain
  needs period : String
  needs goal : Goal? = nil
  needs site_path : String = ""

  def render
    if !goal.nil? && !site_path.empty?
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%", data_days_chart_goal: @goal.not_nil!.id, data_days_chart_site_path: site_path
    elsif !goal.nil?
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%", data_days_chart_goal: @goal.not_nil!.id
    elsif !site_path.empty?
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%", data_days_chart_site_path: site_path
    else
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%"
    end
  end
end
