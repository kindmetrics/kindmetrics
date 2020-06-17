class EventBox < Avram::Box
  def initialize
    name "pageview"
    user_id sequence("session")
    referrer "https://www.test.com/best-analytics"
    url "https://kindmetrics.io/help/test"
    referrer_source nil
    screen_width nil
    path "/help/test"
    device "desktop"
    operative_system "GNU/Linux"
    referrer_domain "www.test.com"
    browser_name "Chrome"
    country "SE"
    session_id SessionBox.create.id
    domain_id DomainBox.create.id
  end
end
