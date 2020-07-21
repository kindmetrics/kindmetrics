class Domains::ShowPage < SecretGuestLayout
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
  quick_def page_title, "Analytics for " + @domain.address

  def content
    render_header
    if total_sum == 0
      m AddTrackingComponent, domain: @domain
    else
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
      div data_controller: "days-chart", data_days_chart_period: @period, data_days_chart_url: "/domains/#{@domain.id}/data/days", height: "300", id: "days_chart", style: "max-height:300px;", width: "100%"
    end
  end

  def render_the_rest
    div class: "max-w-6xl mx-auto p-2 sm:p-0 my-3 mb-6" do
      div class: "w-full grid grid-cols-1 md:grid-cols-3 gap-6" do
        div class: "card" do
          div data_controller: "loader", data_loader_period: @period, data_loader_url: "/domains/#{@domain.id}/data/pages"
        end
        div class: "card" do
          div data_controller: "loader", data_loader_period: @period, data_loader_url: "/domains/#{@domain.id}/data/referrer"
          unless @share_page
            m DetailsLinkComponent, link: Domains::Referrer::Index.with(@domain, @period).url
          else
            m DetailsLinkComponent, link: Share::Referrer::Index.with(@domain.hashid, @period).url
          end
        end
        div class: "card" do
          div class: "relative clear-both", data_controller: "loader", data_loader_period: "<%=@period%>", data_loader_url: "/domains/#{@domain.id}/data/countries"
          unless @share_page
            m DetailsLinkComponent, link: Domains::Countries::Index.with(@domain, @period).url
          else
            m DetailsLinkComponent, link: Share::Countries::Index.with(@domain.hashid, @period).url
          end
        end
        div class: "card" do
          div data_controller: "loader", data_loader_period: @period, data_loader_url: "/domains/#{@domain.id}/data/devices/device"
        end
        div class: "card" do
          div data_controller: "loader", data_loader_period: @period, data_loader_url: "/domains/#{@domain.id}/data/devices/browser"
        end
        div class: "card" do
          div data_controller: "loader", data_loader_period: @period, data_loader_url: "/domains/#{@domain.id}/data/devices/os"
        end
      end
    end
  end

  def render_header
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: @domains, total_sum: @total_sum, period_string: @period_string, period: @period, show_period: total_sum > 0, share_page: @share_page
  end
end
