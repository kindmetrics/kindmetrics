class Users::EditPage < SettingsLayout
  needs operation : SaveUser
  quick_def page_title, "Edit"
  quick_def enable_paddle, false
  quick_def links, [
    {"link" => Users::Edit.url, "name" => "Settings", "icon" => "settings"},
    {"link" => Users::Billing.url, "name" => "Billing", "icon" => "billing"},
  ]
  quick_def active, "Settings"
  quick_def tab, true

  def active
    "Settings"
  end

  def content
    div class: "max-w-2xl mx-auto" do
      h1 "Edit your Settings", class: "text-xl"
      div class: "my-3 card" do
        render_user_form(@operation)
      end
      delete_me
    end
  end

  def render_user_form(op)
    form_for Users::Update do
      m Shared::Field, op.name
      m Shared::Field, op.email

      submit "Update", data_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 mt-4 rounded focus:outline-none focus:shadow-outline"
    end
  end

  def delete_me
    div class: "my-3 card" do
      h2 "Delete Your Account", class: "text-xl"
      para "If you want to leave Kindmetrics and remove your account you can click on the button below.", class: "py-2 text-sm"
      para "Be aware that all data connected to you will also be removed and you can't get it back. You will have to register again if you want to come back.", class: "py-2 text-sm"

      link "Delete Your Account", to: Users::Delete, data_confirm: "Are you sure? All data will be Permantely removed and can't get back", class: "py-2 px-4 bg-red-800 text-white inline-block rounded font-bold", style: "color: white !important"
    end
  end
end
