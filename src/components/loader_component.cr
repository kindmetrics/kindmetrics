class LoaderComponent < BaseComponent
  needs domain : Domain
  needs period : String
  needs url : String
  needs goal : Goal? = nil
  needs site_path : String = ""
  needs style : String = ""

  def render
    if !goal.nil? && !site_path.empty?
      div data_controller: "loader", data_loader_period: period, data_loader_url: "/domains/#{@domain.id}/#{url}", data_loader_goal: goal.not_nil!.id, data_loader_site_path: site_path, class: style
    elsif !goal.nil?
      div data_controller: "loader", data_loader_period: period, data_loader_url: "/domains/#{@domain.id}/#{url}", data_loader_goal: goal.not_nil!.id, class: style
    elsif !site_path.empty?
      div data_controller: "loader", data_loader_period: period, data_loader_url: "/domains/#{@domain.id}/#{url}", data_loader_site_path: site_path, class: style
    else
      div data_controller: "loader", data_loader_period: period, data_loader_url: "/domains/#{@domain.id}/#{url}", class: style
    end
  end
end
