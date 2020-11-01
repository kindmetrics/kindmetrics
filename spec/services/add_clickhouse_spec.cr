require "../spec_helper"

describe AddClickhouse do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "get events for user" do
    user = UserBox.create
    domain = DomainBox.create &.user_id(user.id)
    EventHandler.create_session(user_id: "gsddddddr", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, referrer_medium: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", language: "en", page_load: 453, length: 0, is_bounce: 1, domain_id: domain.id)
    AddClickhouse.all_events_count(user).should eq(1)
  end

  it "get events for user with no domains" do
    user = UserBox.create
    AddClickhouse.all_events_count(user).should eq(0)
  end

  it "get events for user with domains but no events" do
    user = UserBox.create
    domain = DomainBox.create &.user_id(user.id)
    AddClickhouse.all_events_count(user).should eq(0)
  end
end
