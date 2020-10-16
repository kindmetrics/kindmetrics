class HeaderComponent < BaseComponent
  include SubscriptionCheck
  needs active : String = "Dashboard"
  needs domain : Domain
  needs domains : DomainQuery?
  needs share_page : Bool = false
  needs total_sum : Int64 = 0
  needs from : Time = Time.utc - 7.days
  needs to : Time = Time.utc
  needs period : String
  needs period_string : String = "7 days"
  needs show_period : Bool = true
  needs current_url : String
  needs current_user : User?
  needs site_path : String?
  needs source : String?
  needs medium : String?
  needs goal : Goal? = nil

  def links
    if share_page?
      [
        {"link" => Share::Show.url(@domain.hashid, to: to, from: from), "name" => "Dashboard"},
        {"link" => Share::Referrer::Index.url(@domain.hashid, to: to, from: from), "name" => "Referrers"},
        {"link" => Share::Countries::Index.url(@domain.hashid, to: to, from: from), "name" => "Countries"},
      ]
    else
      [
        {"link" => Domains::Show.url(@domain, to: to, from: from), "name" => "Dashboard"},
        {"link" => Domains::Referrer::Index.url(@domain, to: to, from: from), "name" => "Referrers"},
        {"link" => Domains::Countries::Index.url(@domain, to: to, from: from), "name" => "Countries"},
        {"link" => Domains::Goals::Index.url(@domain, to: to, from: from), "name" => "Goals"},
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
                span "0 current active user", data_target: "current-refresh.counter"
              end
            end
          else
            div class: "flex items-center" do
              div class: "md:mx-2 current-counter-container", data_controller: "current-refresh", data_current_refresh_url: "/domains/#{@domain.id}/data/current", data_current_refresh_refresh_interval: "10000" do
                span "0 current active user", data_target: "current-refresh.counter"
              end
            end
          end
          div class: "flex" do
            if !current_user.nil? && !subscription_user_check
              mount TrialComponent, current_user: current_user.not_nil!
            end
            if show_period?
              mount PeriodDropdownComponent, to: to, from: from, period: period, period_string: period_string, domain: domain, site_path: site_path, source: source, medium: medium, goal: goal, current_user: current_user
            end
          end
        end

        # div class: "clear-both w-full pt-2 mt-3" do
        #  mount TabMenu, links: links, active: @active, domain: @domain if @total_sum > 0
        # end
      end
    end
  end
end
