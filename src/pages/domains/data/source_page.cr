class Domains::Data::SourcePage < Domains::Data::BasePage
  needs referrers : Array(StatsReferrer)

  def render
    if referrers.empty?
      span class: "block text-center" do
        text "No sources"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent, first_header: "Source", second_header: "Visitors" do
      @referrers.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-8" do
        div class: "w-full h-7" do
          div class: "progress_bar", style: "width: #{(row.percentage || 0.001)*100}%;height: 30px"
          if !row.referrer_domain.nil? && row.referrer_domain.not_nil! == domain.address
            span class: "block px-2", style: "margin-top: -1.6rem;" do
              text "(direct)"
            end
          else
            a class: "block px-2 hover:underline truncate md:w-48 xl:w-56", style: "margin-top: -1.6rem;", href: get_url(row) do
              img src: "https://api.faviconkit.com/#{row.referrer_domain}/16", class: "inline align-middle mr-2 h-4 w-4 -mt-1"
              text row.referrer_source.to_s
              unless row.referrer_medium.nil?
                text " / #{row.referrer_medium.not_nil!}"
              end
            end
          end
        end
      end
      td class: "w-1/6 h-8 py-1" do
        div class: "text-right" do
          text row.count
        end
      end
    end
  end

  def get_url(row)
    if current_user.nil?
      Share::Show.with(share_id: domain.hashid, goal_id: goal.try { |g| g.id } || 0_i64, site_path: site_path, source_name: row.referrer_source.to_s, from: time_to_string(from), to: time_to_string(to)).url
    else
      Domains::Show.with(domain_id: domain.id, goal_id: goal.try { |g| g.id } || 0_i64, site_path: site_path, source_name: row.referrer_source.to_s, from: time_to_string(from), to: time_to_string(to)).url
    end
  end
end
