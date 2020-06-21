class HeaderComponent < BaseComponent

  needs active : String = "Dashboard"
  needs domain : Domain
  needs domains : DomainQuery?
  needs share_page : Bool = false
  needs total_sum : Int64 = 0
  needs period : String = "7d"
  needs period_string : String = "7 days"
  needs show_period : Bool = true

  def links
    if share_page?
      [
        {"link" => Share::Show.url(@domain.hashid, period: period), "name" => "Dashboard"},
        {"link" => Share::Referrer::Index.url(@domain.hashid, period: period), "name" => "Referrers"},
        {"link" => Share::Countries::Index.url(@domain.hashid, period: period), "name" => "Countries"}
      ]
    else
      [
        {"link" => Domains::Show.url(@domain, period: period), "name" => "Dashboard"},
        {"link" => Domains::Referrer::Index.url(@domain, period: period), "name" => "Referrers"},
        {"link" => Domains::Countries::Index.url(@domain, period: period), "name" => "Countries"},
        {"link" => Domains::Edit.url(@domain), "name" => "Settings"}
      ]
    end
  end

  def render
    div class: "gradient-color" do
      div class: "mt-4 max-w-6xl mx-auto pt-6 px-2 sm:px-0 border-t" do
        div class: "flex justify-between items-center" do
          if @share_page
            div class: "w-2/3" do
              h1 "Analytics for #{@domain.address}", class: "text-xl block w-full"
              div class: "current-counter-container", data_controller: "current-refresh", data_current_refresh_url: "/domains/#{@domain.id}/data/current", data_current_refresh_refresh_interval: "10000" do
                span "0", class: "current-counter", data_target: "current-refresh.counter"
                raw " current active users"
              end
            end
          else
            div class: "flex items-center" do
              render_template "domains/dropdown"
              div class: "md:mx-2 current-counter-container", data_controller: "current-refresh", data_current_refresh_url: "/domains/#{@domain.id}/data/current", data_current_refresh_refresh_interval: "10000" do
                span "0", class: "current-counter", data_target: "current-refresh.counter"
                raw " current active users"
              end
            end
          end
          div do
            if show_period?
              render_template "domains/period_dropdown"
            end
          end
        end

        div class: "clear-both w-full pt-2 mt-2" do
          mount TabMenu.new(links: links, active: @active) if @total_sum > 0
        end
      end
    end
  end
end
