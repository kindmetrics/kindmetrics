class SaveUser < User::SaveOperation
  permit_columns email, name

  before_save do
    validate_required email
    validate_uniqueness_of email
    validate_required name
  end
end
