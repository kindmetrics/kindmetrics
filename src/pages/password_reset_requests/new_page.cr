class PasswordResetRequests::NewPage < AuthLayout
  needs operation : RequestPasswordReset

  def content
    div class: "bg-white shadow-lg rounded p-4" do
      h2 "Reset your password"
      render_form(@operation)
    end
  end

  private def render_form(op)
    form_for PasswordResetRequests::Create do
      mount Shared::Field.new(op.email, "Email"), &.email_input(autofocus: "true", append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
      submit "Reset Password", flow_id: "request-password-reset-button", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    end
  end
end
