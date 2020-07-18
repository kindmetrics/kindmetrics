class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    render_sign_in_form(@operation)
  end

  private def render_sign_in_form(op)
    div class: "card" do
      h2 "Sign In", class: "text-xl"
      form_for SignIns::Create do
        sign_in_fields(op)
        submit "Sign In", flow_id: "sign-in-button", class: "w-full mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
      end
    end
    div class: "w-full text-center mt-2" do
      link "Sign up", to: SignUps::New
    end
  end

  private def sign_in_fields(op)
    m Shared::Field.new(op.email, "Email"), &.email_input(append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")
    m Shared::Field.new(op.password, "Password"), &.password_input(append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")
    div class: "mb-2 -mt-1 text-sm flex justify-between" do
      para "Forgot your password?", class: "inline-block"
      link "Reset password", to: PasswordResetRequests::New, class: "inline-block"
    end
  end
end
