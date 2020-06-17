class CreateSession < Session::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  # permit_columns column_1, column_2

  after_save :create_event

  before_save do
    validate_required user_id
    validate_required domain_id
  end

  def create_event(session : Session)
    SaveEvent.create!(
      user_id: session.user_id,
      name: "pageview",
      referrer: session.referrer,
      country: session.country,
      referrer_domain: session.referrer_domain,
      device: session.device,
      browser_name: session.browser_name,
      operative_system: session.operative_system,
      url: session.url,
      path: session.path,
      referrer_source: session.referrer_source,
      domain_id: session.domain_id,
      session_id: session.id
    )
  end
end
