class Admins::IndexPage < AdminLayout
  needs domains : DomainQuery
  needs users : UserQuery
  needs confirmed_users : UserQuery
  quick_def page_title, "Admin"

  def content
    div class: "max-w-6xl mx-auto py-6 sm:px-6 lg:px-8 p-5 my-3 mb-6" do
      h1 "Admin"
      m TotalAdminDataComponent.new(total_users: users.clone.select_count, total_confirmed_users: confirmed_users.select_count, total_domains: domains.select_count)
      render_user_list
    end
  end

  def render_user_list
    div class: "my-2 card" do
      table class: "table-auto" do
        thead do
          tr do
            th class: "w-1/2 text-left px-2 py-2 text-xs uppercase text-gray-700" do
              raw "Email"
            end
            th class: "w-1/4 px-2 py-2 text-left text-xs uppercase text-gray-700" do
              raw "Name"
            end
            th class: "w-1/4 px-2 py-2 text-left text-xs uppercase text-gray-700" do
              raw "confirmed?"
            end
            th class: "w-1/4 px-2 py-2 text-left text-xs uppercase text-gray-700" do
              raw "Have Domains?"
            end
            th class: "w-1/4 px-2 py-2 text-xs uppercase text-gray-700" do
              raw "Delete"
            end
          end
        end
        tbody do
          users.clone.each do |ur|
            tr do
              td class: "w-1/2 px-2 py-2" do
                raw ur.email
              end
              td class: "w-1/4 px-2 py-2" do
                raw ur.name || ""
              end
              td class: "w-1/4 px-2 py-2" do
                unless ur.confirmed_at.nil?
                  img src: "/assets/svg/check.svg", class: "h-4 w-4 inline-block"
                end
              end
              td class: "w-1/4 px-2 py-2" do
                if DomainQuery.new.user_id(ur.id).select_count > 0
                  img src: "/assets/svg/check.svg", class: "h-4 w-4 inline-block"
                end
              end
              td class: "w-1/4 px-2 py-2" do
                raw "soon"
              end
            end
          end
        end
      end
    end
  end
end
