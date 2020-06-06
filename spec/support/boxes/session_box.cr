class SessionBox < Avram::Box
  def initialize
    user_id sequence("event")
    referrer "https://www.test.com/best-analytics"
    url "https://kindmetrics.io/help/test"
    source nil
    screen_width nil
    path "/help/test"
    device "desktop"
    operative_system "GNU/Linux"
    referrer_domain "www.test.com"
    browser_name "Chrome"
    browser_version "81.0.4044.113"
    country "SE"
    length 0
    is_bounce 1
    domain_id DomainBox.create.id
  end
end
