class Domains::Data::ReferrerPage < Domains::Data::BasePage
  needs referrers : Array(StatsReferrer)

  def render
    if referrers.empty?
      span class: "block text-center" do
        text "No referrers"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent, first_header: "Referrer", second_header: "Visitors" do
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
          if (row.not_nil!.referrer_url || row.not_nil!.referrer_domain || "").to_s.empty?
            span class: "block px-2 truncate", style: "margin-top: -1.6rem;" do
              text "Direct"
            end
          else
            a href: row.not_nil!.referrer_url || "#", class: "block px-2 hover:underline truncate md:w-48 xl:w-56", style: "margin-top: -1.6rem;", rel: "noreferrer" do
              text (row.not_nil!.referrer_url || row.not_nil!.referrer_domain || "").to_s
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
end
