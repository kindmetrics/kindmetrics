require "../spec_helper"

describe EventHandler do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end
  it "is current session" do
    user_id = "event1212461"
    session_id = Random.new.rand(0.to_i64..Int64::MAX)
    AddClickhouse.session_insert(id: session_id, user_id: user_id, name: "pageview", length: nil, is_bounce: 1, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", referrer_medium: "referrer", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: DomainFactory.create.id)
    session = AddClickhouse.get_session(user_id)
    AddClickhouse.event_insert(session_id: session.not_nil!.id, name: "pageview", user_id: user_id, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", referrer_medium: "referrer", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: session.not_nil!.domain_id)

    response = EventHandler.is_current_session?(user_id)
    response.should eq(true)
  end

  it "is current session with events" do
    id = Random.new.rand(Int64)
    user_id = "event12332112"
    session_id = Random.new.rand(0.to_i64..Int64::MAX)
    AddClickhouse.session_insert(id: session_id, user_id: user_id, name: "pageview", length: nil, is_bounce: 1, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", referrer_medium: "referrer", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: DomainFactory.create.id)
    session = AddClickhouse.get_session(user_id)

    AddClickhouse.event_insert(session_id: session.not_nil!.id, name: "pageview", user_id: user_id, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", referrer_medium: "referrer", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: session.not_nil!.domain_id)

    response = EventHandler.is_current_session?(user_id)
    response.should eq(true)
  end

  it "is old session" do
    user_id = "event3463421"
    session_id = Random.new.rand(0.to_i64..Int64::MAX)
    AddClickhouse.session_insert(id: session_id, user_id: user_id, name: "pageview", length: nil, is_bounce: 1, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", referrer_medium: "referrer", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: DomainFactory.create.id, created_at: 80.minutes.ago)
    session = AddClickhouse.get_session(user_id)

    response = EventHandler.is_current_session?(session.not_nil!.user_id)
    response.should eq(false)
  end

  it "is current session with events" do
    user_id = "event8673353"

    EventHandler.create_session(user_id: user_id, name: "pageview", length: 0, is_bounce: 1, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", referrer_medium: "referrer", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: DomainFactory.create.id)
    session = AddClickhouse.get_session(user_id)

    response = EventHandler.is_current_session?(user_id)
    response.should eq(false)
  end

  it "already done session" do
    user_id = "event78945322"
    session_id = Random.new.rand(0.to_i64..Int64::MAX)
    AddClickhouse.session_insert(id: session_id, user_id: user_id, name: "pageview", length: 23.to_i64, is_bounce: 1, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", referrer_medium: "referrer", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: DomainFactory.create.id, created_at: 80.minutes.ago)
    session = AddClickhouse.get_session(user_id)

    AddClickhouse.event_insert(session_id: session.not_nil!.id, name: "pageview", user_id: user_id, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", referrer_medium: "referrer", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", browser_name: "Chrome", country: "SE", language: "en", page_load: 453, domain_id: session.not_nil!.domain_id)

    response = EventHandler.is_current_session?(user_id)
    response.should eq(false)
  end

  it "add event to current session" do
    domain = DomainFactory.create
    user_id = "event679831441"

    EventHandler.create_session(user_id: user_id, name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, referrer_medium: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", language: "en", page_load: 453, length: nil, is_bounce: 0, domain_id: domain.id)
    session = AddClickhouse.get_session(user_id)

    events = AddClickhouse.get_last_event(session.not_nil!)

    events.size.should eq(1)
  end
end
