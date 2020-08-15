class SidebarComponent < BaseComponent
  needs active : String = "Dashboard"
  needs share_page : Bool = false
  needs current_url : String
  needs current_user : User?
  needs domain : Domain?
  needs period : String = "7d"
  needs domains : DomainQuery?

  def render
      div class: "hidden", data_toggle_name: "sidebar-1" do
        div class: "fixed inset-0 flex z-40" do
          div class: "fixed inset-0" do
            div class: "absolute inset-0 bg-gray-600 opacity-75"
          end
          div class: "relative flex-1 flex flex-col max-w-xs w-full bg-white" do
            div class: "absolute top-0 right-0 mr-14 p-1" do
              button aria_label: "Close sidebar", class: "flex items-center justify-center h-12 w-12 rounded-full focus:outline-none focus:bg-gray-600", data_action:"toggle#toggle", data_toggle_target:"sidebar-1" do
                tag "svg", class: "h-6 w-6 text-white", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
                  tag "path", d: "M6 18L18 6M6 6l12 12", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2"
                end
              end
            end
            div class: "flex-1 h-0 pt-5 pb-4 overflow-y-auto" do
              div class: "flex-shrink-0 flex items-center px-2" do
                if !domain.nil? && !current_user.nil?
                  m DomainDropdownComponent, domain: domain.not_nil!, domains: domains
                elsif !domain.nil?
                  text domain.not_nil!.address
                end
              end
              nav class: "mt-5 px-2 space-y-1" do
                links.each do |l|
                  class_names = if l["name"] == active
                    "group flex items-center px-2 py-2 text-sm leading-5 font-medium text-gray-900 rounded-md bg-gray-100 hover:text-gray-900 hover:bg-gray-100 focus:outline-none focus:bg-gray-200 transition ease-in-out duration-150"
                  else
                    "group flex items-center px-2 py-2 text-sm leading-5 font-medium text-gray-600 rounded-md hover:text-gray-900 hover:bg-gray-50 focus:outline-none focus:text-gray-900 focus:bg-gray-50 transition ease-in-out duration-150"
                  end
                  a class: class_names, href: l["link"] do
                    if !l["icon"].empty?
                      tag "svg", class: "mr-3 h-6 w-6 text-gray-500 group-hover:text-gray-500 group-focus:text-gray-600 transition ease-in-out duration-150", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
                        tag "path", d: "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2"
                      end
                    end
                    text l["name"]
                  end
                end
              end
            end
            div class: "flex-shrink-0 flex border-t border-gray-200 p-4" do
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
          div class: "flex flex-col h-0 flex-1 border-r border-gray-200 bg-white" do
            div class: "flex-1 flex flex-col pt-5 pb-4 overflow-y-auto" do
              div class: "flex items-center flex-shrink-0 px-2" do
                if !domain.nil? && !current_user.nil?
                  m DomainDropdownComponent, domain: domain.not_nil!, domains: domains
                elsif !domain.nil?
                  text domain.not_nil!.address
                end
              end
              nav class: "mt-5 flex-1 px-2 bg-white space-y-1" do
                links.each do |l|
                  class_names = if l["name"] == active
                    "group flex items-center px-2 py-2 text-sm leading-5 font-medium text-gray-900 rounded-md bg-gray-100 hover:text-gray-900 hover:bg-gray-100 focus:outline-none focus:bg-gray-200 transition ease-in-out duration-150"
                  else
                    "group flex items-center px-2 py-2 text-sm leading-5 font-medium text-gray-600 rounded-md hover:text-gray-900 hover:bg-gray-50 focus:outline-none focus:text-gray-900 focus:bg-gray-50 transition ease-in-out duration-150"
                  end
                  a class: class_names, href: l["link"] do
                    if !l["icon"].empty?
                      tag "svg", class: "mr-3 h-6 w-6 text-gray-500 group-hover:text-gray-500 group-focus:text-gray-600 transition ease-in-out duration-150", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
                        tag "path", d: "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2"
                      end
                    end
                    text l["name"]
                  end
                end
              end
            end
            div class: "flex-shrink-0 flex border-t border-gray-200 p-4" do
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
        {"link" => Home::Index.url, "name" => "Dashboard", "icon" => ""},
        {"link" => Users::Edit.url, "name" => "Settings", "icon" => ""},
        {"link" => SignIns::Delete.url, "name" => "Sign out", "icon" => ""},
      ]
    end
    if share_page?
      [
        {"link" => Share::Show.url(domain.not_nil!.hashid, period: period), "name" => "Dashboard", "icon" => ""},
        {"link" => Share::Referrer::Index.url(domain.not_nil!.hashid, period: period), "name" => "Referrers", "icon" => ""},
        {"link" => Share::Countries::Index.url(domain.not_nil!.hashid, period: period), "name" => "Countries", "icon" => ""},
      ]
    else
      [
        {"link" => Domains::Show.url(domain.not_nil!, period: period), "name" => "Dashboard", "icon" => ""},
        {"link" => Domains::Referrer::Index.url(domain.not_nil!, period: period), "name" => "Referrers", "icon" => ""},
        {"link" => Domains::Countries::Index.url(domain.not_nil!, period: period), "name" => "Countries", "icon" => ""},
        {"link" => Domains::Goals::Index.url(domain.not_nil!, period: period), "name" => "Goals", "icon" => ""},
        {"link" => Domains::Edit.url(domain.not_nil!), "name" => "Settings", "icon" => ""},
        {"link" => Domains::EditReports.url(domain.not_nil!), "name" => "Reports", "icon" => ""},
      ]
    end
  end

end
