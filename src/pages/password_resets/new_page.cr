class PasswordResets::NewPage < AuthLayout
  needs operation : ResetPassword
  needs user_id : Int64

  def content
    div class: "" do
      h2 "Reset your password", class: "text-xl"
      render_password_reset_form(@operation)
    end
  end

  private def render_password_reset_form(op)
    form_for PasswordResets::Create.with(@user_id) do
      mount Shared::Field, op.password, "Password", &.password_input(append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")
      mount Shared::Field, op.password_confirmation, "Confirm Password", &.password_input(append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")

      submit "Update Password", flow_id: "update-password-button", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end
end
