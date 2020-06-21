class SaveReportUser < ReportUser::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  permit_columns email, weekly, monthly
  before_save do
    unsubcribe_token.value = Random::Secure.urlsafe_base64(32)
    validate_required domain_id
    validate_required email
  end
end
