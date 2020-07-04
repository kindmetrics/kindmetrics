require "../spec_helper"

describe TimeWorker do
  before_each do
    AddClickhouse.clean_database
  end
  it "no events attached to session" do
    user_id = "evwesafsafas"
    AddClickhouse.session_insert(user_id: user_id, length: nil, is_bounce: 1, referrer: "indiehacker.com", url: "https://kindmetrics.com/aaadsad", referrer_source: "indiehacker.com", path: "/asadasd", device: "Desktop", operative_system: "Mac OS", referrer_domain: "indiehacker.com", browser_name: "Chrome", country: "SE", domain_id: DomainBox.create.id)
    session = AddClickhouse.get_session(user_id)
    session.not_nil!.length.should eq(nil)
    session.not_nil!.is_bounce.should eq(1)

    TimeWorker.session_time_check(session.not_nil!.id)

    session = AddClickhouse.get_session(user_id)

    session.not_nil!.length.should eq(nil)
    session.not_nil!.is_bounce.should eq(1)
  end

  it "has one event attached" do
    user_id = "sdfsdgsgs"
    EventHandler.create_session(user_id: user_id, name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: nil, is_bounce: 1, domain_id: DomainBox.create.id, created_at: 34.minutes.ago)
    session = AddClickhouse.get_session(user_id)

    session.not_nil!.length.should eq(nil)
    session.not_nil!.is_bounce.should eq(1)

    TimeWorker.session_time_check(session.not_nil!.id)
    sleep 1
    session = AddClickhouse.get_session(user_id)
    session.not_nil!.length.should eq(0)
    session.not_nil!.is_bounce.should eq(1)
  end
end
