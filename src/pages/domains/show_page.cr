class Domains::ShowPage < SecretGuestLayout
  include Timeparser
  needs domains : DomainQuery?
  needs domain : Domain
  needs real_count : Int64
  needs total_unique : Int64
  needs total_sum : Int64
  needs total_bounce : Int64
  needs total_unique_previous : Int64
  needs total_previous : Int64
  needs total_bounce_previous : Int64
  needs length : Int64
  needs length_previous : Int64
  needs from : Time = Time.utc - 7.days
  needs to : Time = Time.utc
  needs period : String
  needs period_string : String
  needs share_page : Bool = false
  needs site_path : String = ""
  needs source : String = ""
  needs medium : String = ""
  needs active : String = "Dashboard"
  needs goal : Goal?
  quick_def page_title, "Analytics for " + @domain.address

  def content
    render_header
    if real_count == 0
      m AddTrackingComponent, domain: @domain
    else
      render_query_tabs
      render_total
      div class: "gradient-color" do
        div class: "mb-6" do
          div class: "" do
            render_canvas
          end
        end
      end
      render_the_rest
    end
  end

  def render_query_tabs
    return if goal.nil? && site_path.empty? && source.empty? && medium.empty?
    div class: "gradient-color" do
      div class: "px-2 sm:px-0 pt-4" do
        if !goal.nil?
          taber("Goal", goal.not_nil!.name, share_page? ? Share::Show.with(**generate_share_params("goal"), from: time_to_string(from), to: time_to_string(to)) : Domains::Show.with(**generate_params("goal"), from: time_to_string(from), to: time_to_string(to)))
        end
        if !site_path.empty?
          taber("Path", site_path, share_page? ? Share::Show.with(**generate_share_params("site_path"), from: time_to_string(from), to: time_to_string(to)) : Domains::Show.with(**generate_params("site_path"), from: time_to_string(from), to: time_to_string(to)))
        end
        if !source.empty?
          taber("Source", source, share_page? ? Share::Show.with(**generate_share_params("source_name"), from: time_to_string(from), to: time_to_string(to)) : Domains::Show.with(**generate_params("source_name"), from: time_to_string(from), to: time_to_string(to)))
        end
        if !medium.empty?
          taber("Medium", medium, share_page? ? Share::Show.with(**generate_share_params("medium_name"), from: time_to_string(from), to: time_to_string(to)) : Domains::Show.with(**generate_params("medium_name"), from: time_to_string(from), to: time_to_string(to)))
        end
      end
    end
  end

  def taber(name : String, value : String, close)
    div class: "inline-block mini-card text-black mr-2 bg-white items-center" do
      span class: "mr-2" do
        text "#{name}: #{value}"
      end
      link to: close do
        tag "svg", class: "h-4 w-4 stroke-current inline-block mb-1", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
          tag "line", x1: "18", x2: "6", y1: "6", y2: "18"
          tag "line", x1: "6", x2: "18", y1: "6", y2: "18"
        end
      end
    end
  end

  def render_total
    m TotalRowComponent, @total_unique, @total_sum, @total_bounce, @total_unique_previous, @total_previous, @total_bounce_previous, @length, @length_previous
  end

  def render_canvas
    div style: "max-height:320px;" do
      m DaysLoaderComponent, domain: @domain, from: time_to_string(from), to: time_to_string(to), goal: @goal, site_path: site_path, source: source, medium: medium
    end
  end

  def render_the_rest
    div class: "p-2 sm:p-0 my-3 mb-6" do
      div class: "w-full grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6" do
        div class: "card" do
          if source.empty? && medium.empty?
            m LoaderComponent, domain: @domain, url: "data/pages", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
          else
            m LoaderComponent, domain: @domain, url: "data/entry_pages", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
          end
        end
        div class: "card" do
          if source.empty?
            m LoaderComponent, domain: @domain, url: "data/sources", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
            if @share_page
              m DetailsLinkComponent, link: Share::Referrer::Index.with(@domain.hashid, from: time_to_string(from), to: time_to_string(to)).url
            else
              m DetailsLinkComponent, link: Domains::Referrer::Index.with(@domain, from: time_to_string(from), to: time_to_string(to)).url
            end
          else
            m LoaderComponent, domain: @domain, url: "data/referrers", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
            if @share_page
              m DetailsLinkComponent, link: Share::Referrer::Show.with(@domain.hashid, source: source, from: time_to_string(from), to: time_to_string(to)).url
            else
              m DetailsLinkComponent, link: Domains::Referrer::Show.with(@domain, source: source, from: time_to_string(from), to: time_to_string(to)).url
            end
          end
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/countries", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, style: "relative clear-both", source: source, medium: medium
          if @share_page
            m DetailsLinkComponent, link: Share::Countries::Index.with(@domain.hashid, from: time_to_string(from), to: time_to_string(to)).url
          else
            m DetailsLinkComponent, link: Domains::Countries::Index.with(@domain, from: time_to_string(from), to: time_to_string(to)).url
          end
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/devices/device", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/devices/browser", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
        end
        div class: "card" do
          m LoaderComponent, domain: @domain, url: "data/devices/os", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
        end
      end
      render_goals unless @goal
      # render_promo if share_page? && current_user.nil?
    end
  end

  def render_promo
    m PromoComponent, domain
  end

  def render_goals
    m LoaderComponent, domain: @domain, url: "data/goals", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium
  end

  def render_header
    m HeaderComponent, domain: @domain, current_url: context.request.path, domains: @domains, total_sum: @total_sum, period_string: @period_string, from: from, to: to, period: period, show_period: real_count > 0, share_page: @share_page, current_user: current_user, goal: goal, site_path: site_path, medium: medium, source: source
  end

  def generate_params(kind : String)
    {
      domain_id:   domain.id,
      goal_id:     !goal.nil? && kind != "goal" ? goal.not_nil!.id : 0_i64,
      site_path:   site_path.empty? || kind == "site_path" ? "" : site_path,
      source_name: source.empty? || kind == "source_name" ? "" : source,
      medium_name: medium.empty? || kind == "medium_name" ? "" : medium,
    }
  end

  def generate_share_params(kind : String)
    {
      share_id:    domain.hashid,
      goal_id:     !goal.nil? && kind != "goal" ? goal.not_nil!.id : 0_i64,
      site_path:   site_path.empty? || kind == "site_path" ? "" : site_path,
      source_name: source.empty? || kind == "source_name" ? "" : source,
      medium_name: medium.empty? || kind == "medium_name" ? "" : medium,
    }
  end
end
