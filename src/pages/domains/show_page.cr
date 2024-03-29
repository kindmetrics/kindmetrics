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
  needs site_path : String?
  needs source : String?
  needs medium : String?
  needs country : String?
  needs country_name : String?
  needs browser : String?
  needs active : String = "Dashboard"
  needs goal : Goal?
  quick_def page_title, "Analytics for " + @domain.address

  def content
    render_header
    if real_count == 0
      mount AddTrackingComponent, domain: @domain
    else
      render_query_tabs
      render_total
      div class: "mb-6" do
        div class: "bg-white rounded-md mb-6 border border-kind-gray" do
          div class: "mb-2" do
            div class: "min-h-10 " do
              render_canvas
            end
          end
        end
        render_the_rest
      end
    end
  end

  def render_query_tabs
    return if goal.nil? && site_path.nil? && source.nil? && medium.nil? && country.nil? && browser.nil?
    from_string = unless from.nil?
      time_to_string(from.not_nil!)
    end
    to_string = unless to.nil?
      time_to_string(to.not_nil!)
    end
    div class: "gradient-color" do
      div class: "px-2 sm:px-0 pt-4" do
        if !goal.nil?
          taber("Goal", goal.not_nil!.name, share_page? ? Share::Show.with(**generate_share_params("goal"), from: from_string, to: to_string) : Domains::Show.with(**generate_params("goal"), from: from_string, to: to_string))
        end
        if !site_path.nil?
          taber("Path", site_path.not_nil!, share_page? ? Share::Show.with(**generate_share_params("site_path"), from: from_string, to: to_string) : Domains::Show.with(**generate_params("site_path"), from: from_string, to: to_string))
        end
        if !source.nil?
          taber("Source", source.not_nil!, share_page? ? Share::Show.with(**generate_share_params("source"), from: from_string, to: to_string) : Domains::Show.with(**generate_params("source"), from: from_string, to: to_string))
        end
        if !medium.nil?
          taber("Medium", medium.not_nil!, share_page? ? Share::Show.with(**generate_share_params("medium"), from: from_string, to: to_string) : Domains::Show.with(**generate_params("medium"), from: from_string, to: to_string))
        end
        if !country.nil?
          taber("Country", country_name.not_nil!, share_page? ? Share::Show.with(**generate_share_params("country"), from: from_string, to: to_string) : Domains::Show.with(**generate_params("country"), from: from_string, to: to_string))
        end
        if !browser.nil?
          taber("Browser", browser.not_nil!, share_page? ? Share::Show.with(**generate_share_params("browser"), from: from_string, to: to_string) : Domains::Show.with(**generate_params("browser"), from: from_string, to: to_string))
        end
      end
    end
  end

  def taber(name : String, value : String, close)
    div class: "inline-block mini-card text-white mr-2 bg-white items-center" do
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
    mount TotalRowComponent, @total_unique, @total_sum, @total_bounce, @total_unique_previous, @total_previous, @total_bounce_previous, @length, @length_previous
  end

  def render_canvas
    div class: "align-middle", style: "max-height:320px; min-height:315px;" do
      mount DaysLoaderComponent, domain: @domain, from: time_to_string(from), to: time_to_string(to), goal: @goal, site_path: site_path, source: source, medium: medium, country: country, browser: browser
    end
  end

  def render_the_rest
    from_string = unless from.nil?
      time_to_string(from.not_nil!)
    end
    to_string = unless to.nil?
      time_to_string(to.not_nil!)
    end
    div class: "w-full grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6" do
      div class: "card" do
        if source.nil? && medium.nil?
          mount LoaderComponent, domain: @domain, url: "data/pages", goal: @goal, from: from_string, to: to_string, site_path: site_path, source: source, medium: medium, country: country, browser: browser
        else
          mount LoaderComponent, domain: @domain, url: "data/entry_pages", goal: @goal, from: from_string, to: to_string, site_path: site_path, source: source, medium: medium, country: country, browser: browser
        end
      end
      div class: "card" do
        if source.nil?
          mount LoaderComponent, domain: @domain, url: "data/sources", goal: @goal, from: from_string, to: to_string, site_path: site_path, source: source, medium: medium, country: country, browser: browser
          if @share_page
            mount DetailsLinkComponent, link: Share::Referrer::Index.with(@domain.hashid, from: from_string, to: to_string).url
          else
            mount DetailsLinkComponent, link: Domains::Referrer::Index.with(@domain, from: from_string, to: to_string).url
          end
        else
          mount LoaderComponent, domain: @domain, url: "data/referrers", goal: @goal, from: from_string, to: to_string, site_path: site_path, source: source, medium: medium, country: country, browser: browser
          if @share_page
            mount DetailsLinkComponent, link: Share::Referrer::Show.with(@domain.hashid, source_name: source || "", from: from_string, to: to_string).url
          else
            mount DetailsLinkComponent, link: Domains::Referrer::Show.with(@domain, source_name: source || "", from: from_string, to: to_string).url
          end
        end
      end
      div class: "card" do
        mount LoaderComponent, domain: @domain, url: "data/countries", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, style: "relative clear-both", source: source, medium: medium, country: country, browser: browser
        if @share_page
          mount DetailsLinkComponent, link: Share::Countries::Index.with(@domain.hashid, from: time_to_string(from), to: time_to_string(to)).url
        else
          mount DetailsLinkComponent, link: Domains::Countries::Index.with(@domain, from: time_to_string(from), to: time_to_string(to)).url
        end
      end
      div class: "card" do
        mount LoaderComponent, domain: @domain, url: "data/devices/device", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium, country: country, browser: browser
      end
      div class: "card" do
        mount LoaderComponent, domain: @domain, url: "data/devices/browser", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium, country: country, browser: browser
      end
      div class: "card" do
        mount LoaderComponent, domain: @domain, url: "data/devices/os", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium, country: country, browser: browser
      end
    end
    render_goals unless @goal
    # render_promo if share_page? && current_user.nil?
  end

  def render_promo
    mount PromoComponent, domain
  end

  def render_goals
    mount LoaderComponent, domain: @domain, url: "data/goals", goal: @goal, from: time_to_string(from), to: time_to_string(to), site_path: site_path, source: source, medium: medium, country: country, browser: browser
  end

  def render_header
    mount HeaderComponent, domain: @domain, current_url: context.request.path, domains: @domains, total_sum: @total_sum, period_string: @period_string, from: from, to: to, period: period, show_period: real_count > 0, share_page: @share_page, current_user: current_user, goal: goal, site_path: site_path, medium: medium, source: source, country: country, browser: browser
  end

  def generate_params(kind : String)
    {
      domain_id: domain.id,
      goal_id:   !goal.nil? && kind != "goal" ? goal.not_nil!.id : nil,
      site_path: site_path.nil? || kind == "site_path" ? nil : site_path,
      source:    source.nil? || kind == "source" ? nil : source,
      medium:    medium.nil? || kind == "medium" ? nil : medium,
      country:   country.nil? || kind == "country" ? nil : country,
      browser:   browser.nil? || kind == "browser" ? nil : browser,
    }
  end

  def generate_share_params(kind : String)
    {
      share_id:  domain.hashid,
      goal_id:   !goal.nil? && kind != "goal" ? goal.not_nil!.id : nil,
      site_path: site_path.nil? || kind == "site_path" ? nil : site_path,
      source:    source.nil? || kind == "source" ? nil : source,
      medium:    medium.nil? || kind == "medium" ? nil : medium,
      country:   country.nil? || kind == "country" ? nil : country,
      browser:   browser.nil? || kind == "browser" ? nil : browser,
    }
  end
end
