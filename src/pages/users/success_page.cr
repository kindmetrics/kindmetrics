class Users::SuccessPage < SettingsLayout
  quick_def page_title, "Success"
  quick_def enable_paddle, true
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
    div class: "max-w-2xl mx-auto text-center" do
      h1 "Success!", class: "text-3xl text-center"

      para "Your payment went through! You are now one of the kind ones!"

      para "Thanks for supporting Kindmetrics, I will forever remember this gesture."

      div class: "w-full text-center mt-6" do
        link "Go To Dashboard", to: Home::Index, class: "bg-blue-800 rounded px-4 py-4 text-xl text-white font-semibold text-center inline-block"
      end
    end
  end
end
