class UpdateDomain < Domain::SaveOperation
  include FixAddress
  needs current_user : User
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  permit_columns address, time_zone, shared

  after_save :set_current_domain

  before_save do
    validate_required address
    validate_required time_zone
    validate_uniqueness_of address
  end

  def set_current_domain(domain)
    return unless current_user.current_domain.nil?

    SaveUser.update!(current_user, current_domain_id: domain.id)
  end
end
