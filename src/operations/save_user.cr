class SaveUser < User::SaveOperation
  permit_columns email

  before_save do
    validate_required email
    validate_uniqueness_of email
  end
end
