class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    render_sign_up_form(@operation)
  end

  private def render_sign_up_form(op)
    div class: "" do
      form_for SignUps::Create do
        sign_up_fields(op)
        submit "Sign Up", flow_id: "sign-up-button", class: "w-full mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      end
    end
    div class: "w-full text-center mt-2" do
      link "Sign in instead", to: SignIns::New
    end
  end

  private def sign_up_fields(op)
    mount Shared::Field, op.name
    mount Shared::Field, op.email, "Email", &.email_input(append_class: "w-full form-input my-2 leading-tight")
    mount Shared::Field, op.password, "Password", &.password_input(append_class: "w-full form-input my-2 leading-tight")
    mount Shared::Field, op.password_confirmation, "Confirm Password", &.password_input(append_class: "w-full form-input my-2 leading-tight")
  end
end
