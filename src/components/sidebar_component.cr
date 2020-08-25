class SidebarComponent < BaseComponent
  needs active : String = "Dashboard"
  needs share_page : Bool = false
  needs current_url : String
  needs current_user : User?
  needs domain : Domain?
  needs period : String = "7d"
  needs domains : DomainQuery?
  needs total_sum : Int64 = 1_i64

  def render
      div class: "hidden", data_toggle_name: "sidebar-1" do
        div class: "fixed inset-0 flex z-40" do
          div class: "relative flex-1 flex flex-col w-full bg-white" do
            div class: "flex-1 h-0 pt-5 pb-4 overflow-y-auto" do
              div class: "flex-shrink-0 flex items-center px-2 mb-5" do
                button aria_label: "Close sidebar", class: "group flex items-center px-2 w-full text-md bg-menu-button py-2 leading-5 font-medium text-gray-600 rounded-md hover:text-gray-900 hover:bg-gray-50 focus:outline-none focus:text-gray-900 focus:bg-gray-50 transition ease-in-out duration-150", data_action:"toggle#toggle", data_toggle_target:"sidebar-1" do
                  text "Close menu"
                end
              end
              div class: "flex-shrink-0 flex items-center px-2" do
                if !domain.nil? && !current_user.nil?
                  m DomainDropdownComponent, domain: domain.not_nil!, domains: domains
                elsif !domain.nil?
                  div class: "inline-block select-none rounded-md p-3 text-md transister w-full", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
                    span class: "appearance-none flex items-center justify-between inline-block text-lg" do
                      span class: "flex items-center" do
                        img src: "https://api.faviconkit.com/#{domain.not_nil!.address}/32", class: "inline align-middle h-6 w-6 mr-2"
                        text domain.not_nil!.address
                      end
                    end
                  end
                end
              end
              if total_sum > 0
                nav class: "mt-5 space-y-1" do
                  links.each do |l|
                    if l["name"] == active
                      class_names = "group flex items-center px-4 py-2 text-sm leading-5 blue-numbers font-semibold bg-gray-100 hover:text-gray-900 hover:bg-gray-300 focus:outline-none focus:bg-gray-200 transition ease-in-out duration-150"
                      svg_class = "blue-numbers"
                    else
                      class_names ="group flex items-center px-4 py-2 text-sm leading-5 font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-200 focus:outline-none focus:text-gray-900 focus:bg-gray-50 transition ease-in-out duration-150"
                      svg_class = "text-gray-600"
                    end
                    a class: class_names, href: l["link"] do
                      if !l["icon"].empty?
                        icon(l["icon"],"h-4 w-4 align-middle inline mr-2 fill-current #{svg_class}")
                      end
                      text l["name"]
                    end
                  end
                end
              end
            end
            div class: "flex-shrink-0 flex border-t border-gray-200 p-4 hover:bg-cool-gray-50" do
              link to: Users::Edit, class: "flex-shrink-0 group block focus:outline-none" do
                div class: "flex items-center" do
                  div class: "ml-3" do
                    para class: "text-base leading-6 font-medium text-gray-700 group-hover:text-gray-900" do
                      text (!current_user.nil? ? current_user.not_nil!.name : "No name").to_s
                    end
                    para class: "text-sm leading-5 font-medium text-gray-500 group-hover:text-gray-700 group-focus:underline transition ease-in-out duration-150" do
                      text " Settings "
                    end
                  end
                end
              end
            end
          end
          div " ", class: "flex-shrink-0 w-14"
        end
      end
      div class: "hidden md:flex md:flex-shrink-0 h-screen sticky top-0" do
        div class: "flex flex-col w-64" do
          div class: "flex flex-col h-0 flex-1 bg-cool-gray-50" do
            div class: "flex-1 flex flex-col pt-5 pb-4 overflow-y-auto" do
              div class: "flex items-center flex-shrink-0 px-2" do
                if !domain.nil? && !current_user.nil?
                  m DomainDropdownComponent, domain: domain.not_nil!, domains: domains
                elsif !domain.nil?
                  div class: "inline-block select-none rounded-md p-3 text-md transister w-full", data_action: "click->dropdown#toggle click@window->dropdown#hide", role: "button" do
                    span class: "appearance-none flex items-center justify-between inline-block text-lg" do
                      span class: "flex items-center" do
                        img src: "https://api.faviconkit.com/#{domain.not_nil!.address}/32", class: "inline align-middle h-6 w-6 mr-2"
                        text domain.not_nil!.address
                      end
                    end
                  end
                end
              end
              if total_sum > 0
                nav class: "mt-5 flex-1 bg-cool-gray-50 space-y-1" do
                  links.each do |l|
                    if l["name"] == active
                      class_names = "group flex items-center px-4 py-2 text-sm leading-5 blue-numbers font-semibold bg-cool-gray-100 hover:text-gray-900 hover:bg-cool-gray-200 focus:outline-none focus:bg-gray-200 transition ease-in-out duration-150"
                      svg_class = "blue-numbers"
                    else
                      class_names ="group flex items-center px-4 py-2 text-sm leading-5 font-medium text-gray-600 hover:text-gray-900 hover:bg-cool-gray-100 focus:outline-none focus:text-gray-900 focus:bg-gray-50 transition ease-in-out duration-150"
                      svg_class = "text-gray-600"
                    end
                    a class: class_names, href: l["link"] do
                      if !l["icon"].empty?
                        icon(l["icon"],"h-4 w-4 align-middle inline mr-2 fill-current #{svg_class}")
                      end
                      text l["name"]
                    end
                  end
                end
              end
            end
            div class: "flex-shrink-0 flex p-4 hover:bg-gray-50" do
              link to: Users::Edit, class: "flex-shrink-0 w-full group block" do
                div class: "flex items-center" do
                  div class: "ml-3" do
                    para class: "text-sm leading-5 font-medium text-gray-700 group-hover:text-gray-900" do
                      text (!current_user.nil? ? current_user.not_nil!.name : "No name").to_s
                    end
                    para class: "text-xs leading-4 font-medium text-gray-500 group-hover:text-gray-700 transition ease-in-out duration-150" do
                      text " Settings "
                    end
                  end
                end
              end
            end
          end
        end
      end
  end

  def links
    if domain.nil?
      return [
        {"link" => Home::Index.url, "name" => "Dashboard", "icon" => "dashboard"},
        {"link" => Users::Edit.url, "name" => "Settings", "icon" => "settings"},
        {"link" => Users::Billing.url, "name" => "Billing", "icon" => "billing"},
        {"link" => SignIns::Delete.url, "name" => "Sign out", "icon" => ""},
      ]
    end
    if share_page?
      [
        {"link" => Share::Show.url(domain.not_nil!.hashid, period: period), "name" => "Dashboard", "icon" => "dashboard"},
        {"link" => Share::Referrer::Index.url(domain.not_nil!.hashid, period: period), "name" => "Referrers", "icon" => "referrers"},
        {"link" => Share::Countries::Index.url(domain.not_nil!.hashid, period: period), "name" => "Countries", "icon" => "countries"},
      ]
    else
      [
        {"link" => Domains::Show.url(domain.not_nil!, period: period), "name" => "Dashboard", "icon" => "dashboard"},
        {"link" => Domains::Referrer::Index.url(domain.not_nil!, period: period), "name" => "Referrers", "icon" => "referrers"},
        {"link" => Domains::Countries::Index.url(domain.not_nil!, period: period), "name" => "Countries", "icon" => "countries"},
        {"link" => Domains::Goals::Index.url(domain.not_nil!, period: period), "name" => "Goals", "icon" => "goals"},
        {"link" => Domains::Edit.url(domain.not_nil!), "name" => "Settings", "icon" => "settings"},
        {"link" => Domains::EditReports.url(domain.not_nil!), "name" => "Reports", "icon" => "reports"},
      ]
    end
  end

  def icon(kind : String, classes : String)
    case kind
    when "billing"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", clip_rule: "evenodd", d: "M20 4H4C2.89001 4 2.01001 4.89001 2.01001 6L2 18C2 19.11 2.89001 20 4 20H20C21.11 20 22 19.11 22 18V6C22 4.89001 21.11 4 20 4ZM20 18H4V12H20V18ZM4 8H20V6H4V8Z", fill_rule: "evenodd"
      end
    when "dashboard"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", d: "M23 8C23 9.1 22.1 10 21 10C20.82 10 20.65 9.98 20.49 9.93L16.93 13.48C16.98 13.64 17 13.82 17 14C17 15.1 16.1 16 15 16C13.9 16 13 15.1 13 14C13 13.82 13.02 13.64 13.07 13.48L10.52 10.93C10.36 10.98 10.18 11 10 11C9.82 11 9.64 10.98 9.48 10.93L4.93 15.49C4.98 15.65 5 15.82 5 16C5 17.1 4.1 18 3 18C1.9 18 1 17.1 1 16C1 14.9 1.9 14 3 14C3.18 14 3.35 14.02 3.51 14.07L8.07 9.52C8.02 9.36 8 9.18 8 9C8 7.9 8.9 7 10 7C11.1 7 12 7.9 12 9C12 9.18 11.98 9.36 11.93 9.52L14.48 12.07C14.64 12.02 14.82 12 15 12C15.18 12 15.36 12.02 15.52 12.07L19.07 8.51C19.02 8.35 19 8.18 19 8C19 6.9 19.9 6 21 6C22.1 6 23 6.9 23 8Z"
      end
    when "countries"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", clip_rule: "evenodd", d: "M20.34 3.03003L20.5 3C20.78 3 21 3.21997 21 3.5V18.62C21 18.85 20.85 19.03 20.64 19.1L15 21L9 18.9L3.66003 20.97L3.5 21C3.21997 21 3 20.78 3 20.5V5.38C3 5.15002 3.15002 4.96997 3.35999 4.90002L9 3L15 5.09998L20.34 3.03003ZM9 16.78L15 18.89V7.21997L9 5.10999V16.78Z", fill_rule: "evenodd"
      end
    when "settings"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", clip_rule: "evenodd", d: "M15 9H17V7H21V5H17V3H15V9ZM7 9V11H3V13H7V15H9V9H7ZM13 19V21H11V15H13V17H21V19H13ZM3 19V17H9V19H3ZM21 11V13H11V11H21ZM13 5H3V6.98999H13V5Z", fill_rule: "evenodd"
      end
    when "referrers"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", clip_rule: "evenodd", d: "M3.90002 12C3.90002 10.29 5.28998 8.9 7 8.9H11V7H7C4.23999 7 2 9.24 2 12C2 14.76 4.23999 17 7 17H11V15.1H7C5.28998 15.1 3.90002 13.71 3.90002 12ZM8 13H16V11H8V13ZM13 7H17C19.76 7 22 9.24 22 12C22 14.76 19.76 17 17 17H13V15.1H17C18.71 15.1 20.1 13.71 20.1 12C20.1 10.29 18.71 8.9 17 8.9H13V7Z", fill_rule: "evenodd"
      end
    when "goals"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", clip_rule: "evenodd", d: "M13 4L14 6H20V16H13L12 14H7V21H5V4H13ZM14 14H18V8H13L12 6H7V12H13L14 14Z", fill_rule: "evenodd"
      end
    when "reports"
      return tag "svg", class: classes, viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg" do
        tag "path", clip_rule: "evenodd", d: "M20 4H4C2.89999 4 2.01001 4.90002 2.01001 6L2 18C2 19.1 2.89999 20 4 20H20C21.1 20 22 19.1 22 18V6C22 4.90002 21.1 4 20 4ZM4 8L12 13L20 8V18H4V8ZM4 6L12 11L20 6H4Z", fill_rule: "evenodd"
      end
    else
      return nil
    end
  end

end
