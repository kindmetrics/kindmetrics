class Domains::Data::PagespeedPathPage < Domains::Data::BasePage
  needs paths : Array(StatsPagespeedPath)

  def render
    if paths.empty?
      span class: "block text-center" do
        text "No pages"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent, first_header: "Path", second_header: "Page Load" do
      paths.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-8" do
        div class: "w-full h-7" do
          a class: "block px-2 hover:underline truncate md:w-48 xl:w-56", href: get_url(row) do
            text row.address.to_s
          end
        end
      end
      td class: "w-1/6 h-8 py-1" do
        div class: "text-right" do
          text row.page_load.to_s
        end
      end
    end
  end

  def get_url(row)
    if current_user.nil?
      Share::Show.with(share_id: domain.hashid, goal_id: goal.try { |g| g.id }, site_path: row.address.to_s, source: source, medium: medium, from: time_to_string(from), to: time_to_string(to)).url
    else
      Domains::Show.with(domain_id: domain.id, goal_id: goal.try { |g| g.id }, site_path: row.address.to_s, source: source, medium: medium, from: time_to_string(from), to: time_to_string(to)).url
    end
  end
end
