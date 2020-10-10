require "../../../spec_helper"

describe Api::Events::Create do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end
  it "domain not set" do
    response = ApiClient.exec(Api::Events::Create, test: "")
    response.status_code.should eq(404)
  end

  it "domain don't exists" do
    response = ApiClient.exec(Api::Events::Create, domain: "test.com")
    response.status_code.should eq(404)
  end

  it "events get created for domain" do
    domain = DomainBox.create

    domain.events.size.should eq(0)

    response = ApiClient.exec(Api::Events::Create, name: "pageview", domain: domain.address, user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36", referrer: nil, url: "https://#{domain.address}/asdsadasds", source: nil)

    response.status_code.should eq(200)
    AddClickhouse.get_domain_events(domain.id).size.should eq(1)
    AddClickhouse.get_domain_sessions(domain.id).size.should eq(1)
  end

  it "events ignored if bot" do
    domain = DomainBox.create

    domain.events.size.should eq(0)

    response = ApiClient.exec(Api::Events::Create, name: "pageview", domain: domain.address, user_agent: "DuckDuckBot/1.0; (+http://duckduckgo.com/duckduckbot.html)", referrer: nil, url: "https://#{domain.address}/", source: nil)

    response.status_code.should eq(200)
    AddClickhouse.get_domain_events(domain.id).size.should eq(0)
    AddClickhouse.get_domain_sessions(domain.id).size.should eq(0)
  end

  it "Do not save non-existing events" do
    domain = DomainBox.create

    domain.events.size.should eq(0)

    response = ApiClient.exec(Api::Events::Create, name: "sign_up", domain: domain.address, user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36", referrer: nil, url: "https://#{domain.address}/", source: nil)
    response.status_code.should eq(200)

    AddClickhouse.get_domain_events(domain.id).size.should eq(0)
    AddClickhouse.get_domain_sessions(domain.id).size.should eq(0)
  end

  it "Do save existing events" do
    domain = DomainBox.create
    goal = GoalBox.create &.name("sign_up").domain_id(domain.id)

    domain.events.size.should eq(0)

    response = ApiClient.exec(Api::Events::Create, name: "sign_up", domain: domain.address, user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36", referrer: nil, url: "https://#{domain.address}/", source: nil)
    response.status_code.should eq(200)

    events = AddClickhouse.get_domain_events(domain.id)
    events.size.should eq(1)
    events.first.name.should eq("sign_up")

    sessions = AddClickhouse.get_domain_sessions(domain.id)
    sessions.size.should eq(1)
    sessions.first.name.should eq("sign_up")
  end
end
