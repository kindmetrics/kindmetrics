class Users::EditPage < MainLayout
  needs operation : SaveUser
  quick_def page_title, "Edit"
  quick_def single_page, "Edit my Settings"

  def content
    div class: "mt-20 max-w-xl mx-auto py-6 sm:px-6 lg:px-8 p-5" do
      h1 "Edit your Settings", class: "text-xl"
      div class: "my-3 card" do
        render_user_form(@operation)
      end
    end
  end

  def render_user_form(op)
    form_for Users::Update do
      mount Shared::Field.new(op.name)
      mount Shared::Field.new(op.email)

      submit "Update", data_disable_with: "Updating...", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 mt-4 rounded focus:outline-none focus:shadow-outline"
    end
  end
end
