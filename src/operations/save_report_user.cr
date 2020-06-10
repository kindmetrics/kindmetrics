class SaveReportUser < ReportUser::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  permit_columns email
  before_save do
    validate_required domain_id
    validate required email
  end
end
