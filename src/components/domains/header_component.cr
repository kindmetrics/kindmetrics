class HeaderComponent < BaseComponent
  include SubscriptionCheck
  needs active : String = "Dashboard"
  needs domain : Domain
  needs domains : DomainQuery?
  needs share_page : Bool = false
  needs total_sum : Int64 = 0
  needs period : String = "7d"
  needs period_string : String = "7 days"
  needs show_period : Bool = true
  needs current_url : String
  needs current_user : User?

  def links
    if share_page?
      [
        {"link" => Share::Show.url(@domain.hashid, period: period), "name" => "Dashboard"},
        {"link" => Share::Referrer::Index.url(@domain.hashid, period: period), "name" => "Referrers"},
        {"link" => Share::Countries::Index.url(@domain.hashid, period: period), "name" => "Countries"},
      ]
    else
      [
        {"link" => Domains::Show.url(@domain, period: period), "name" => "Dashboard"},
        {"link" => Domains::Referrer::Index.url(@domain, period: period), "name" => "Referrers"},
        {"link" => Domains::Countries::Index.url(@domain, period: period), "name" => "Countries"},
        {"link" => Domains::Goals::Index.url(@domain, period: period), "name" => "Goals"},
        {"link" => Domains::Edit.url(@domain), "name" => "Settings"},
        {"link" => Domains::EditReports.url(@domain), "name" => "Reports"},
      ]
    end
  end

  def render
    div class: "gradient-color" do
      div class: "" do
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
              div class: "md:mx-2 current-counter-container", data_controller: "current-refresh", data_current_refresh_url: "/domains/#{@domain.id}/data/current", data_current_refresh_refresh_interval: "10000" do
                span "0", class: "current-counter", data_target: "current-refresh.counter"
                raw " current active users"
              end
            end
          end
          div class: "flex" do
            if !current_user.nil? && subscription_user_check
              m TrialComponent, current_user: current_user.not_nil!
            end
            if show_period?
              m PeriodDropdownComponent, period_string, current_url
            end
          end
        end

        # div class: "clear-both w-full pt-2 mt-3" do
        #  m TabMenu, links: links, active: @active, domain: @domain if @total_sum > 0
        # end
      end
    end
  end
end
