class SaveDomain < Domain::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  permit_columns address, time_zone

  before_save do
    validate_required address
    validate_required time_zone
    validate_uniqueness_of address
  end
end
