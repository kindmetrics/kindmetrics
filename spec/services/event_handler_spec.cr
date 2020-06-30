require "../spec_helper"

describe EventHandler do
  it "is current session" do
    session = SessionBox.create &.user_id("test_id").length(nil)

    response = EventHandler.is_current_session?(session.user_id)
    response.should eq(true)
  end

  it "is current session with events" do
    domain = DomainBox.create
    id = Random.new.rand(Int64)
    user_id = "event12332112"
    EventHandler.create_session(user_id: user_id, name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: nil, is_bounce: 0, domain_id: domain.id)

    response = EventHandler.is_current_session?(user_id)
    response.should eq(true)
  end

  it "is old session" do
    session = SessionBox.create &.created_at(80.minutes.ago).length(nil)

    response = EventHandler.is_current_session?(session.user_id)
    response.should eq(false)
  end

  it "is current session with events" do
    event = EventBox.create &.created_at(50.minutes.ago)
    event.domain_id = event.session!.not_nil!.domain_id

    response = EventHandler.is_current_session?(event.session!.not_nil!.user_id)
    response.should eq(false)
  end

  it "already done session" do
    session = SessionBox.create &.created_at(80.minutes.ago).length(23.to_i64)

    response = EventHandler.is_current_session?(session.user_id)
    response.should eq(false)
  end

  it "add event to current session" do
    domain = DomainBox.create
    id = Random.new.rand(Int64)
    user_id = "event12332112"

    EventHandler.create_session(user_id: user_id, name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: nil, is_bounce: 0, domain_id: domain.id)

    events = AddClickhouse.get_last_event(id)
    pp! events
    events.size.should eq(1)
  end
end
