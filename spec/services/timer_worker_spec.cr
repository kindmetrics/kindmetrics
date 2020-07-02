require "../spec_helper"

describe TimeWorker do
  after_each do
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
end
