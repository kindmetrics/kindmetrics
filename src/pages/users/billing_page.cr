class Users::BillingPage < SettingsLayout
  quick_def enable_paddle, true
  quick_def page_title, "Billing"
  needs subscription : Subscription?
  needs events_count : Int64
  quick_def links, [
    {"link" => Users::Edit.url, "name" => "Settings", "icon" => "settings"},
    {"link" => Users::Billing.url, "name" => "Billing", "icon" => "billing"},
  ]
  quick_def active, "Settings"
  quick_def tab, true

  def active
    "Billing"
  end

  def content
    div class: "max-w-2xl mx-auto" do
      h1 "Billing", class: "text-2xl"
      render_subscription_window
      update_payment_window unless subscription.nil? || subscription.try(&.cancelled?)
      cancel_subscription_window unless subscription.nil? || subscription.try(&.cancelled?)
    end
  end

  def render_subscription_window
    div class: "my-3 border border-gray-200 rounded bg-white p-4" do
      div class: "w-full grid grid-cols-1 md:grid-cols-3 gap-6" do
        div class: "bg-cool-gray-100 rounded text-xl text-gray-800 p-4" do
          if subscription.nil?
            para "Plan", class: "text-sm text-center"
            para "-", class: "text-3xl text-center"
          else
            para subscription.not_nil!.name.to_s, class: "text-sm text-center"
            para subscription.not_nil!.pageviews.try { |p| p.format }.to_s, class: "text-3xl text-center"
          end
        end

        div class: "bg-cool-gray-100 rounded text-xl text-gray-800 p-4" do
          if subscription.nil?
            para "Next billing", class: "text-sm text-center"
            para "-", class: "text-3xl text-center"
          else
            para subscription.not_nil!.cancelled? ? "Ending at" : "Next billing", class: "text-sm text-center"
            para subscription.not_nil!.next_bill_at.to_s("%-d %b"), class: "text-3xl text-center"
          end
        end

        div class: "bg-cool-gray-100 rounded text-xl text-gray-800 p-4" do
          para "Next payment", class: "text-sm text-center"
          if subscription.nil?
            para "-", class: "text-3xl text-center"
          else
            para "#{subscription.not_nil!.price} €", class: "text-3xl text-center"
          end
        end
      end
      h2 "Events last 30 days", class: "text-xl mt-6"
      para events_count.format + " events", class: "font-semibold mb-2"

      if !subscription.nil?
        para "Status: #{subscription.not_nil!.cancelled? ? "Cancelled" : "Ongoing"}"
      else
        para "Status: Trial"
      end

      link "Upgrade", to: Users::Plans, class: "inline-block p-2 font-semibold bg-blue-700 text-white rounded mt-4"
    end
  end

  def update_payment_window
    h2 "Update", class: "text-xl"
    div class: "my-3 border border-gray-200 rounded bg-white p-4", data_controller: "cancel", data_cancel_paddle: KindEnv.env("PADDLE_VENDOR") || "", data_cancel_url: subscription.not_nil!.update_url do
      para "You can update your card details whenever you want."
      a "Update card", href: subscription.not_nil!.update_url, data_action: "click->cancel#cancel", class: "inline-block p-2 mt-4 font-semibold bg-blue-700 text-white rounded"
    end
  end

  def cancel_subscription_window
    h2 "Cancel", class: "text-xl"
    div class: "my-3 border border-gray-200 rounded bg-white p-4", data_controller: "cancel", data_cancel_paddle: KindEnv.env("PADDLE_VENDOR") || "", data_cancel_url: subscription.not_nil!.cancel_url do
      para "you can cancel your subscription and use Kindmetrics until the subscription's next bill date."
      a "Cancel Subscription", href: subscription.not_nil!.cancel_url, data_action: "click->cancel#cancel", class: "inline-block p-2 mt-4 font-semibold bg-red-700 text-white rounded"
    end
  end
end
