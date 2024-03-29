class PeriodDropdownComponent < BaseComponent
  include Timeparser
  needs period_string : String
  needs from : Time
  needs to : Time
  needs period : String
  needs domain : Domain
  needs current_user : User?
  needs site_path : String?
  needs source : String?
  needs medium : String?
  needs country : String?
  needs browser : String?
  needs goal : Goal? = nil
  needs url_action : Lucky::Action.class = Domains::Show

  def render
    div class: "text-sm leading-none rounded no-underline text-gray-700 hover:text-gray-900" do
      div class: "relative", data_controller: "reveal" do
        a href: "", class: "inline-block select-none rounded-md p-3 text-white bg-kind-black transister", data_action: "click->reveal#toggle click@window->reveal#hide", role: "button" do
          span class: "appearance-none flex items-center justify-between inline-block text-base font-medium" do
            span do
              text period_name
            end
            tag "svg", class: "h-4 w-4 ml-2 text-white fill-current", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
              tag "path", d: "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            end
          end
        end
        div class: "absolute right-0 mt-2 w-100 z-20", hidden: "", data_reveal: "", data_transition: "" do
          div class: "bg-white shadow-lg rounded overflow-hidden border border-kind-gray" do
            div class: "flex flex-wrap divide-x divide-kind-gray" do
              div class: "w-1/3 flex flex-wrap divide-y divide-kind-gray" do
                div class: "w-full" do
                  period_url_element("7 days", "7d")
                  period_url_element("30 days", "30d")
                end
                div class: "w-full" do
                  to_from_url_element("This Month", Time.utc.at_beginning_of_month, Time.utc)
                  to_from_url_element("Last month", (Time.utc - 1.month).at_beginning_of_month, (Time.utc - 1.month).at_end_of_month)
                end
                div class: "w-full" do
                  to_from_url_element("Last 6 months", (Time.utc - 6.months), Time.utc)
                  to_from_url_element("Last 12 months", (Time.utc - 12.months), Time.utc)
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
      Share::Show.with(domain.hashid, from: time_to_string(from), to: time_to_string(to), goal_id: goal.try { |g| g.id }, site_path: site_path, source: source, medium: medium, browser: browser, country: country).url
    else
      Domains::Show.with(domain.id, from: time_to_string(from), to: time_to_string(to), goal_id: goal.try { |g| g.id }, site_path: site_path, source: source, medium: medium, browser: browser, country: country).url
    end
  end

  def period_url(period : String)
    if current_user.nil?
      Share::Show.with(domain.hashid, period: period, goal_id: goal.try { |g| g.id }, site_path: site_path, source: source, medium: medium, browser: browser, country: country).url
    else
      Domains::Show.with(domain.id, period: period, goal_id: goal.try { |g| g.id }, site_path: site_path, source: source, medium: medium, browser: browser, country: country).url
    end
  end

  def to_from_url_element(text : String, new_from : Time, new_to : Time = Time.utc)
    a text, href: period_url(new_from, new_to), class: "hover:no-underline block px-4 py-3 text-gray-900 text-xs bg-white w-full hover:bg-cool-gray-100 whitespace-no-wrap #{bold_if_same_date(new_from, new_to)}"
  end

  def period_url_element(text : String, period : String)
    a text, href: period_url(period), class: "hover:no-underline block px-4 py-3 text-gray-900 text-xs bg-white w-full hover:bg-cool-gray-100 whitespace-no-wrap #{bold_if_same_date(period)}"
  end

  def bold_if_same_date(new_from : Time, new_to : Time)
    return "font-bold" if new_from.at_beginning_of_day == from.at_beginning_of_day && new_to.at_end_of_day == to.at_end_of_day
    nil
  end

  def bold_if_same_date(new_period : String)
    from_check = period_time(period).at_beginning_of_day
    return "font-bold" if from_check == from.at_beginning_of_day && period == new_period
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

  def period_time(period : String) : Time
    case period
    when "30d"
      30.days.ago
    when "1m"
      1.month.ago
    else
      7.days.ago
    end
  end
end
