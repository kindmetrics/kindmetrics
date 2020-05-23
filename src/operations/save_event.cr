class SaveEvent < Event::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  before_save do
    validate_required user_id
    validate_required session_id
    validate_required domain_id
  end
end
