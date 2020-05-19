class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    render_sign_in_form(@operation)
  end

  private def render_sign_in_form(op)
    div class: "bg-white shadow-lg rounded p-4" do
      h2 "Sign In"
      form_for SignIns::Create do
        sign_in_fields(op)
        submit "Sign In", flow_id: "sign-in-button", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      end
      link "Reset password", to: PasswordResetRequests::New
      text " | "
      link "Sign up", to: SignUps::New
    end
  end

  private def sign_in_fields(op)
    mount Shared::Field.new(op.email, "Email"), &.email_input(autofocus: "true", append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
    mount Shared::Field.new(op.password, "Password"), &.password_input(append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
  end
end
