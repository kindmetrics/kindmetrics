class SaveEvent < Event::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  before_save do
    validate_required session_id
    validate_required domain_id
    validate_required name
    session = SessionQuery.find(session_id.value.not_nil!)
    user_id.value = session.user_id
    validate_required user_id
  end
end
