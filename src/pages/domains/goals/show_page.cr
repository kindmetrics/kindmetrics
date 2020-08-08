class Domains::Goals::ShowPage < SecretGuestLayout
  needs domains : DomainQuery?
  needs domain : Domain
  needs total_unique : Int64
  needs total_sum : Int64
  needs total_bounce : Int64
  needs total_unique_previous : Int64
  needs total_previous : Int64
  needs total_bounce_previous : Int64
  needs period : String
  needs period_string : String
  needs share_page : Bool = false
  needs goal : Goal
  quick_def page_title, "Analytics for goal " + @goal.name + " at " + @domain.address

  def content
    render_header
    if total_sum == 0
      m AddTrackingComponent, domain: @domain
    else
      render_goal_info
      render_total
      div class: "max-w-6xl mx-auto py-6 sm:px-6 lg:px-8 p-5 my-3 mb-6 card" do
        render_canvas
      end
      render_the_rest
    end
  end

  def render_total
    m TotalRowComponent, @total_unique, @total_sum, @total_bounce, @total_unique_previous, @total_previous, @total_bounce_previous
  end

  def render_canvas
    div style: "max-height:320px;" do
      m DaysLoaderComponent, domain: @domain, period: @period, goal: @goal
    end
  end

  def render_the_rest
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6" do
      div class: "w-full grid grid-cols-1 md:grid-cols-3 gap-6" do
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/pages", goal: @goal, period: @period
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/referrer", goal: @goal, period: @period
          if @share_page
            m DetailsLinkComponent, link: Share::Referrer::Index.with(@domain.hashid, @period).url
          else
            m DetailsLinkComponent, link: Domains::Referrer::Index.with(@domain, @period).url
          end
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/countries", goal: @goal, period: @period, style: "relative clear-both"
          if @share_page
            m DetailsLinkComponent, link: Share::Countries::Index.with(@domain.hashid, @period).url
          else
            m DetailsLinkComponent, link: Domains::Countries::Index.with(@domain, @period).url
          end
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/devices/device", goal: @goal, period: @period
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/devices/browser", goal: @goal, period: @period
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/devices/os", goal: @goal, period: @period
        end
      end
    end
  end

  def render_goal_info
    div class: "max-w-6xl mx-auto p-2 my-3 mb-6" do
      h1 "Goal: " + goal_prefix + @goal.name, class: "text-2xl"
    end
  end

  private def goal_prefix
    if goal.kind == 0
      "Trigger "
    else
      "Visit "
    end
  end

  def render_header
    m HeaderComponent, active: "Goals", domain: @domain, current_url: context.request.path, domains: @domains, total_sum: @total_sum, period_string: @period_string, period: @period, show_period: total_sum > 0, share_page: @share_page
  end
end
