class Domains::Data::PagesPage
  include Lucky::HTMLPage
  needs pages : Array(StatsPages)
  needs period : String
  needs domain : Domain
  needs current_user : User?

  def render
    if pages.empty?
      span class: "block text-center" do
        text "No pages"
      end
    else
      render_table
    end
  end

  def render_table
    mount DashboardTableComponent.new(first_header: "Page", second_header: "Visitors") do
      @pages.each do |r|
        render_row(r)
      end
    end
  end

  def render_row(row)
    tr class: "h-9 text-sm subpixel-antialiased" do
      td class: "w-5/6 py-1 h-9" do
        div class: "w-full h-9" do
          div class: "progress_bar", style: "width: #{(row.percentage || 0.001)*100}%;height: 30px"
          a class: "block px-2 hover:underline truncate", style: "margin-top: -1.6rem;", href: get_url(row) do
            text row.address.to_s
          end
        end
      end
      td class: "w-1/6 h-9 py-1" do
        div class: "text-right" do
          text row.count
        end
      end
    end
  end

  def get_url(row)
    if current_user.nil?
      "/share/#{@domain.hashid}/paths/#{row.address}"
    else
      "/domains/#{@domain.id}/paths/#{row.address}"
    end
  end
end
