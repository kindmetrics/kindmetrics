class Users::PlansPage < MainLayout
  needs operation : SaveUser
  needs subscription : Subscription?
  quick_def page_title, "Edit"
  quick_def enable_paddle, true
  quick_def single_page, "Edit my Settings"

  def active
    "Billing"
  end

  def content
    div class: "max-w-4xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "Plans", class: "text-xl"
      div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row" do
        div class: "w-full", data_controller: "plans", data_plans_paddle: KindEnv.env("PADDLE_VENDOR") || "", data_plans_user: current_user.id, data_plans_email: current_user.email do

          render_list

          div class: "text-right m-2 text-sm" do
            text "Due today:"
            span data_target: "plans.price", class: "font-semibold ml-2"
            para class: "text-xs" do
              text "And then we will charge same per month."
            end
          end
          div class: "w-full pt-2" do
            a "Pay with Paddle", href: "#!", class: "inline-block float-right p-2 bg-blue-700 text-white rounded", data_action: "click->plans#checkout"
          end
        end
        div class: "w-full" do
          h2 "Why Pay for analytics?", class: "text-xl"
          unless subscription.nil?
            text "Have a subsscription with id: " + subscription.not_nil!.id.to_s
            para "plan id: " + subscription.not_nil!.plan_id.to_s
            para "Next bill at: " + subscription.not_nil!.next_bill_at.to_s
            para "price: " + subscription.not_nil!.price.to_s + "€"
          end
        end
      end
    end
  end

  def render_list
    table class: "table-fixed w-full border border-gray-200 rounded block" do
      thead do
        tr class: "w-full" do
          th class: "w-3/6 px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 font-medium text-gray-500 uppercase tracking-wider" do
            span "Plan", class: "lg:pl-2"
          end
          th class: "w-2/6 px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 font-medium text-gray-500 uppercase tracking-wider" do
            text " Price "
          end
          th class: "w-2/6 px-6 py-3 border-b border-gray-200 bg-gray-50 text-left text-xs leading-4 font-medium text-gray-500 uppercase tracking-wider" do
            span "events", class: "lg:pl-2"
          end
        end
      end
      tbody do
        PLANS.each do |p|
          render_plan(p["id"], p["name"], p["views"], p["price"])
        end
      end
    end
  end

  def render_plan(plan : String, name : String, pageviews : Int, price : Int)
    tr data_plan: plan, data_price: price.to_s, data_action: "click->plans#switch", class: "w-full border-b border-gray-200 bg-gray-50 cursor-pointer" do
      td class: "w-3/6 px-6 py-3 whitespace-no-wrap text-sm leading-5 font-medium text-gray-900" do
        div class: "flex items-center lg:pl-2" do
          text name
        end
      end
      td class: "w-2/6 px-6 py-3 text-sm leading-5 font-medium" do
        div class: "flex items-center space-x-2" do
          span  price.to_s+"€", class: "flex-shrink-0 text-xs leading-5 font-medium"
        end
      end
      td class: "w-2/6 px-6 py-3 whitespace-no-wrap text-sm leading-5 font-medium text-gray-900" do
        div class: "flex items-center lg:pl-2" do
          text pageviews.format
        end
      end
    end
  end
end
