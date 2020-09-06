class SignUpUser < User::SaveOperation
  param_key :user
  # Change password validations in src/operations/mixins/password_validations.cr
  include PasswordValidations

  after_commit send_invite_email

  permit_columns email, name
  attribute password : String
  attribute password_confirmation : String

  before_save do
    validate_required email
    validate_required name
    validate_uniqueness_of email
    confirmed_token.value = Random::Secure.urlsafe_base64(32)
    trial_ends_at.value = Time.utc + 14.days
    if Lucky::Env.development?
      Log.debug { {confirmed_token: confirmed_token.value} }
    end
    Authentic.copy_and_encrypt password, to: encrypted_password
  end

  def send_invite_email(user)
    UserConfirmationEmail.new(user).deliver_later
  end
end
