class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    render_sign_in_form(@operation)
  end

  private def render_sign_in_form(op)
    div class: "" do
      form_for SignIns::Create do
        sign_in_fields(op)
        submit "Sign In", flow_id: "sign-in-button", class: "w-full mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      end
    end
    div class: "w-full text-center mt-2" do
      link "Sign up instead", to: SignUps::New
    end
  end

  private def sign_in_fields(op)
    m Shared::Field, op.email, "Email", &.email_input(append_class: "w-full form-input my-2 leading-tight")
    m Shared::Field, op.password, "Password", &.password_input(append_class: "w-full form-input my-2 leading-tight")
    div class: "mb-2 -mt-1 text-sm flex justify-between" do
      para "Forgot your password?", class: "inline-block"
      link "Reset password", to: PasswordResetRequests::New, class: "inline-block"
    end
  end
end
