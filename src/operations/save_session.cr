class SaveSession < Session::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  # permit_columns column_1, column_2
  before_save do
    validate_required user_id
    validate_required domain_id
  end
end
