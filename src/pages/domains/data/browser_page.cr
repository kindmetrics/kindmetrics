class Domains::Data::Devices::BrowsersPage < Domains::Data::BasePage
  needs browsers : Array(StatsBrowser)

  def render
    if browsers.empty?
      span class: "block text-center" do
        text "No browsers"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent, first_header: "Browser", second_header: "Percentage" do
      @browsers.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    percentage = ((row.percentage || 0.001)*100)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-8" do
        div class: "w-full h-7" do
          div class: "progress_bar", style: "width: #{percentage}%;height: 30px"
          a class: "block px-2 hover:underline truncate md:w-48 xl:w-56", style: "margin-top: -1.6rem;", href: get_url(row) do
            text row.browser.to_s
          end
        end
      end
      td class: "w-1/6 h-8 py-1" do
        div class: "text-right" do
          text "#{percentage.to_i}%"
        end
      end
    end
  end
  def get_url(row)
    if current_user.nil?
      Share::Show.with(share_id: domain.hashid, browser: row.browser.to_s, country: country, goal_id: goal.try { |g| g.id }, site_path: site_path, source: source, medium: medium, from: time_to_string(from), to: time_to_string(to)).url
    else
      Domains::Show.with(domain_id: domain.id, browser: row.browser.to_s, country: country, goal_id: goal.try { |g| g.id }, site_path: site_path, source: source, medium: medium, from: time_to_string(from), to: time_to_string(to)).url
    end
  end
end
