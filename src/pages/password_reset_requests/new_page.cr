class PasswordResetRequests::NewPage < AuthLayout
  needs operation : RequestPasswordReset

  def content
    div class: "" do
      h2 "Reset your password", class: "text-xl"
      render_form(@operation)
    end
  end

  private def render_form(op)
    form_for PasswordResetRequests::Create do
      m Shared::Field, op.email, "Email", &.email_input(append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")
      submit "Reset Password", flow_id: "request-password-reset-button", class: "w-full mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end
end
