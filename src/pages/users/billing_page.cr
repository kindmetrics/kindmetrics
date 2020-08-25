class Users::BillingPage < MainLayout
  quick_def enable_paddle, false
  quick_def page_title, "Billing"
  needs subscription : Subscription?
  needs events_count : Int64

  def active
    "Billing"
  end

  def content
    div class: "max-w-2xl mx-auto" do
      h1 "Billing", class: "text-2xl"
      render_subscription_window
    end
  end

  def render_subscription_window
    div class: "my-3 border border-gray-200 rounded bg-white p-4" do
      div class: "w-full grid grid-cols-1 md:grid-cols-3 gap-6" do
        div class: "bg-cool-gray-100 rounded text-xl text-gray-800 p-4" do
          para "Plan Events", class: "text-sm text-center"
          if subscription.nil?
            text "-"
          else
            para subscription.not_nil!.pageviews.try { |p| p.format }.to_s, class: "text-3xl text-center"
          end
        end

        div class: "bg-cool-gray-100 rounded text-xl text-gray-800 p-4" do
          para "Next billing", class: "text-sm text-center"
          if subscription.nil?
            text "-"
          else
            para subscription.not_nil!.next_bill_at.to_s("%-d %b"), class: "text-3xl text-center"
          end
        end

        div class: "bg-cool-gray-100 rounded text-xl text-gray-800 p-4" do
          para "Next payment", class: "text-sm text-center"
          if subscription.nil?
            text "-"
          else
            para subscription.not_nil!.price.to_s + "€", class: "text-3xl text-center"
          end
        end
      end
      h2 "Events last 30 days", class: "text-xl mt-6"
      para events_count.format + " events", class: "font-semibold mb-4"

      link "Upgrade", to: Users::Plans, class: "inline-block p-2 font-semibold bg-blue-700 text-white rounded"
    end
  end

  def cancel_subscription_window
    h2 "Cancel", class: "text-xl"
    div class: "my-3 border border-gray-200 rounded bg-white p-4" do
      para "you can cancel your subscription and use Kindmetrics until the date."
    end
  end
end
