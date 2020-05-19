class SignUpUser < User::SaveOperation
  param_key :user
  # Change password validations in src/operations/mixins/password_validations.cr
  include PasswordValidations

  after_save :send_invite_email

  permit_columns email
  attribute password : String
  attribute password_confirmation : String

  before_save do
    validate_required email
    validate_uniqueness_of email
    confirmed_token.value = Random::Secure.hex(32)
    Authentic.copy_and_encrypt password, to: encrypted_password
  end

  def send_invite_email(user)
    UserConfirmationEmail.new(user).deliver_later
  end
end
