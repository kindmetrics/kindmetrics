class TotalAdminDataComponent < BaseComponent
  needs total_users : Int64
  needs total_confirmed_users : Int64
  needs total_domains : Int64

  def render
    div class: "big_letters" do
      div class: "max-w-6xl mx-auto py-3 px-2 sm:px-0 grid grid-flow-col gap-6" do
        div class: "p-3" do
          para @total_users.to_s, class: "text-3xl strong"
          para "Total Users", class: "text-sm uppercase"
        end
        div class: "p-3" do
          para @total_confirmed_users.to_s, class: "text-3xl strong"
          para "Total Confirmed", class: "text-sm strong uppercase"
        end
        div class: "p-3" do
          para "#{@total_domains.to_s}%", class: "text-3xl strong"
          para "Domains", class: "text-sm strong uppercase"
        end
      end
    end
  end
end
