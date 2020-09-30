class PeriodDropdownComponent < BaseComponent
  include Timeparser
  needs period_string : String
  needs from : Time
  needs to : Time
  needs domain : Domain
  needs current_user : User?
  needs site_path : String = ""
  needs source : String = ""
  needs medium : String = ""
  needs goal : Goal? = nil

  def render
    div class: "text-sm leading-none rounded no-underline text-gray-700 hover:text-gray-900" do
      div class: "relative", data_controller: "reveal" do
        a href: "", class: "inline-block select-none rounded-md p-3 border-kind-gray border bg-white transister", data_action: "click->reveal#toggle click@window->reveal#hide", role: "button" do
          span class: "appearance-none flex items-center justify-between inline-block text-base font-medium" do
            span do
              text period_name
            end
            tag "svg", class: "h-4 w-4 ml-2 text-kind-blue stroke-current", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", d: "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            end
          end
        end
        div class: "absolute right-0 mt-2 w-100 z-20", hidden: "", data_reveal: "", data_transition: "" do
          div class: "bg-white shadow-lg rounded overflow-hidden border border-kind-gray" do
            div class: "flex flex-wrap divide-x divide-kind-gray" do
              div class: "w-1/3 flex flex-wrap divide-y divide-kind-gray" do
                div class: "w-full" do
                  period_url_element("7 days", Time.utc - 7.days, Time.utc)
                  period_url_element("30 days", Time.utc - 30.days, Time.utc)
                end
                div class: "w-full" do
                  period_url_element("This Month", Time.utc.at_beginning_of_month, Time.utc)
                  period_url_element("Last month", (Time.utc - 1.month).at_beginning_of_month, (Time.utc - 1.month).at_end_of_month)
                end
                div class: "w-full" do
                  period_url_element("Last 6 months", (Time.utc - 6.months), Time.utc)
                  period_url_element("Last 12 months", (Time.utc - 12.months), Time.utc)
                end
              end
              div "", class: "w-2/3", data_controller: "date-picker", data_date_picker_mindate: time_to_string(domain.created_at), data_date_picker_maxdate: time_to_string(Time.utc)
            end
          end
        end
      end
    end
  end

  def period_url(from : Time, to : Time = Time.utc)
    if current_user.nil?
      Share::Show.with(domain.hashid, from: time_to_string(from), to: time_to_string(to), goal_id: goal.try { |g| g.id } || 0_i64, site_path: site_path, source_name: source, medium_name: medium).url
    else
      Domains::Show.with(domain.id, from: time_to_string(from), to: time_to_string(to), goal_id: goal.try { |g| g.id } || 0_i64, site_path: site_path, source_name: source, medium_name: medium).url
    end
  end

  def period_url_element(text : String, new_from : Time, new_to : Time = Time.utc)
    a text, href: period_url(new_from, new_to), class: "hover:no-underline block px-4 py-3 text-gray-900 text-xs bg-white w-full hover:bg-cool-gray-100 whitespace-no-wrap #{bold_if_same_date(new_from, new_to)}"
  end

  def bold_if_same_date(new_from : Time, new_to : Time)
    return "font-bold" if new_from.at_beginning_of_day == from.at_beginning_of_day && new_to.at_end_of_day == to.at_end_of_day
    nil
  end

  def period_name
    today = Time.utc
    return "Last #{period_string}" if (today - from).days == 7 || (today - from).days == 30
    return this_month if from.day == 1 && to.day == to.at_end_of_month.day
    "#{stringify_date(from)} - #{stringify_date(to)}"
  end

  def this_month
    from.to_s("%B %Y")
  end

  def stringify_date(date : Time) : String
    today = Time.utc

    return date.to_s("%b %-d %Y") if today.year != date.year

    date.to_s("%b %-d")
  end
end
