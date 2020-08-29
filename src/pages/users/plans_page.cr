class Users::PlansPage < SettingsLayout
  needs operation : SaveUser
  needs subscription : Subscription?
  quick_def page_title, "Edit"
  quick_def enable_paddle, true
  needs events_count : Int64
  quick_def links, [
    {"link" => Users::Edit.url, "name" => "Settings", "icon" => "settings"},
    {"link" => Users::Billing.url, "name" => "Billing", "icon" => "billing"},
  ]
  quick_def active, "Settings"
  quick_def tab, false

  def active
    "Billing"
  end

  def content
    div class: "max-w-2xl mx-auto" do
      h1 "Plans", class: "text-xl"
      para "Events usage last 30 days: #{events_count.format}", class: "text-sm"
      div class: "w-full mt-2", data_controller: "plans", data_plans_paddle: KindEnv.env("PADDLE_VENDOR") || "", data_plans_user: current_user.id, data_plans_success: Users::Plans::Success.url, data_plans_email: current_user.email, data_plans_default: "596767", data_plans_current_plan: subscription.try { |s| s.cancelled? ? "" : s.plan_id }.to_s, data_plans_upgrade: subscription_check do
        div class: "grid grid-cols-1 md:grid-flow-col md:grid-cols-2 gap-6 sm:grid-flow-row" do
          div class: "" do
            render_list
          end

          div do
            unless subscription.nil? || subscription.try {|s| s.cancelled? }
              div class: "p-2 border-gray-200 border rounded mb-2" do
                para "current plan: #{subscription.not_nil!.pageviews.try { |p| p.format }.to_s}", class: "text-cool-gray-600 text-center"
              end
            end
            div class: "p-2 border-gray-200 border rounded" do
              div class: "m-2" do
                para data_target: "plans.price", class: "font-semibold ml-2 text-4xl text-center"
                para "per month", class: "text-cool-gray-500 text-center"
                para class: "mt-2 text-sm text-cool-gray-500 text-center" do
                  text "Events:"
                  span data_target: "plans.event", class: "ml-1"
                end
              end
              div class: "w-full pt-2 object-bottom" do
                a plan_button_text, href: "#!", class: "block w-full text-xl px-2 py-4 bg-blue-700 text-white rounded text-center", data_action: "click->plans#checkout"
              end
            end
          end
        end
      end
    end
  end

  def render_list
    table class: "table-fixed w-full border border-gray-200 rounded block" do
      thead do
        tr class: "w-full" do
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
    tr data_plan: plan, data_price: price.to_s, data_events: pageviews.format, data_action: "click->plans#switch", class: "w-full border-b border-gray-200 bg-white cursor-pointer" do
      td class: "w-2/6 px-6 py-3 text-sm leading-5 font-medium" do
        div class: "flex items-center space-x-2" do
          span price.to_s + "€", class: "flex-shrink-0 text-xs leading-5 font-medium"
        end
      end
      td class: "w-2/6 px-6 py-3 whitespace-no-wrap text-sm leading-5 font-medium" do
        div class: "flex items-center lg:pl-2" do
          text pageviews.format
        end
      end
    end
  end

  def subscription_check
    return false if subscription.nil?
    return false if subscription.not_nil!.cancelled?
    true
  end

  def plan_button_text
    return "Pay with Paddle" if subscription.nil?
    return "Switch plan" if !subscription.not_nil!.cancelled?
    "Rejoin with Paddle"
  end
end
