class UserConfirmations::ConfirmPage < AuthLayout
  needs user : User
  quick_def page_title, "Not Confirmed"

  def content
    text "Failed to confirm."
    br
    link "Sign in", to: SignIns::New
  end
end
