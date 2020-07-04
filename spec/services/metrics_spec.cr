require "../spec_helper"

describe Metrics do
  before_each do
    AddClickhouse.clean_database
  end
  it "unique calculation" do
    domain = DomainBox.create

    EventHandler.create_session(user_id: "11231212", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: nil, is_bounce: 0, domain_id: domain.id)
    EventHandler.create_session(user_id: "53443534", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: nil, is_bounce: 0, domain_id: domain.id)

    metrics = Metrics.new(domain, "7d")
    unique = metrics.unique_query
    unique.should eq(2)
  end

  it "total calculation" do
    domain = DomainBox.create
    user_id = "event973231"

    EventHandler.create_session(user_id: user_id, name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: nil, is_bounce: 0, domain_id: domain.id)
    session = AddClickhouse.get_session(user_id)

    EventHandler.add_event(user_id: user_id, name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", domain_id: domain.id)

    metrics = Metrics.new(domain, "7d")
    total_views = metrics.total_query
    total_views.should eq(2)
  end

  it "bounce calculation" do
    domain = DomainBox.create
    EventHandler.create_session(user_id: "53443534", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)
    EventHandler.create_session(user_id: "2423432", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)

    metrics = Metrics.new(domain, "7d")
    bounce_rate = metrics.bounce_query
    bounce_rate.should eq(100)
  end

  # it "bounce with 50/50 calculation" do
  #  domain = DomainBox.create
  #
  #  EventHandler.create_session(user_id: "1573435124370987", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)
  #  EventHandler.create_session(user_id: "12441241565512", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 234, is_bounce: 0, domain_id: domain.id)
  #
  #  metrics = Metrics.new(domain, "7d")
  #  bounce_rate = metrics.bounce_query
  #  # It push down the bounce_rate, that's why it is 30 and not 50.
  #  bounce_rate.should eq(30)
  # end

  it "7 days calculation" do
    domain = DomainBox.create
    EventHandler.create_session(user_id: "dsfdsfdsf", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)
    EventHandler.create_session(user_id: "f32532ewfds", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)

    metrics = Metrics.new(domain, "7d")
    days, today, data = metrics.get_days
    days.not_nil!.size.should eq(8)
    data.not_nil!.size.should eq(7)
    today.not_nil!.size.should eq(8)

    days.not_nil!.last.day.should eq(Time.utc.day)
    days.not_nil!.last.month.should eq(Time.utc.month)

    days.not_nil!.first.day.should eq((Time.utc - 7.days).day)
    days.not_nil!.first.month.should eq((Time.utc - 7.days).month)
  end

  it "fill empty days" do
    domain = DomainBox.create
    EventHandler.create_session(user_id: "gsddddddr", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)
    EventHandler.create_session(user_id: "236t5fvsdx", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)

    metrics = Metrics.new(domain, "7d")
    days, today, data = metrics.get_days
    days.not_nil!.size.should eq(8)
    data.not_nil!.size.should eq(7)
    today.not_nil!.size.should eq(8)

    empty_days = data.try { |d| d[0..(data.not_nil!.size || 1) - 1] }
    empty_days.not_nil!.size.should eq(7)

    empty_days.not_nil!.each { |ed| ed.should eq(0) }

    empty_today = today.try { |t| t[0..(today.not_nil!.size || 1) - 3] }
    empty_today.not_nil!.size.should eq(6)

    empty_today.not_nil!.each { |ed| ed.should eq(nil) }
  end

  it "14 days calculation" do
    domain = DomainBox.create
    EventHandler.create_session(user_id: "gsddddddr", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)
    EventHandler.create_session(user_id: "236t5fvsdx", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)

    metrics = Metrics.new(domain, "14d")
    days, today, data = metrics.get_days
    days.not_nil!.size.should eq(15)
    data.not_nil!.size.should eq(14)
    today.not_nil!.size.should eq(15)

    days.not_nil!.last.day.should eq(Time.utc.day)
    days.not_nil!.last.month.should eq(Time.utc.month)

    days.not_nil!.first.day.should eq((Time.utc - 14.days).day)
    days.not_nil!.first.month.should eq((Time.utc - 14.days).month)
  end
end
