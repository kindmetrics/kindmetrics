require "../spec_helper"

describe TimeWorker do
  it "no events attached to session" do
    session = SessionBox.create &.user_id("test_id").length(nil)

    session.length.should eq(nil)
    session.is_bounce.should eq(true)

    TimeWorker.timedout(session)

    session = session.reload
    session.length.should eq(nil)
    session.is_bounce.should eq(true)
  end

  it "has one event attached" do
    session = SessionBox.create &.user_id("test_id").length(nil)
    event = EventBox.create &.user_id("test_id").session_id(session.id).domain_id(session.domain_id).created_at(Time.utc - 34.minutes)

    session.length.should eq(nil)
    session.is_bounce.should eq(true)

    TimeWorker.timedout(session)

    session = session.reload
    session.length.should eq(0)
    session.is_bounce.should eq(true)
  end

  it "has two event attached" do
    session = SessionBox.create &.user_id("test_id").length(nil)

    event1 = EventBox.create &.session_id(session.id).domain_id(session.domain_id).created_at(Time.utc - 34.minutes)
    event2 = EventBox.create &.session_id(session.id).domain_id(session.domain_id).created_at(Time.utc - 32.minutes)

    session.length.should eq(nil)
    session.is_bounce.should eq(true)

    TimeWorker.timedout(session)

    session = session.reload
    session.length.should eq(120)
    session.is_bounce.should eq(false)
  end
end
