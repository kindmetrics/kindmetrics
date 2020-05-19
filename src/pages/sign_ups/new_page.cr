class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    render_sign_up_form(@operation)
  end

  private def render_sign_up_form(op)
    div class: "bg-white shadow-lg rounded p-4" do
      h2 "Sign Up"
      form_for SignUps::Create do
        sign_up_fields(op)
        submit "Sign Up", flow_id: "sign-up-button", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      end
      link "Sign in instead", to: SignIns::New
    end
  end

  private def sign_up_fields(op)
    mount Shared::Field.new(op.email, "Email"), &.email_input(append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
    mount Shared::Field.new(op.password, "Password"), &.password_input(append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
    mount Shared::Field.new(op.password_confirmation, "Confirm Password"), &.password_input(append_class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline my-2")
  end
end
