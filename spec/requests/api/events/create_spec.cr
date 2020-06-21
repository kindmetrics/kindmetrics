require "../../../spec_helper"

describe Events::Create do
  it "domain not set" do
    response = AppClient.exec(Events::Create, test: "")
    response.status_code.should eq(404)
  end

  it "domain don't exists" do
    response = AppClient.exec(Events::Create, domain: "test.com")
    response.status_code.should eq(404)
  end

  it "events get created for domain" do
    domain = DomainBox.create

    domain.events!.size.should eq(0)

    response = AppClient.exec(Events::Create, domain: domain.address, user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36", referrer: nil, url: "https://#{domain.address}/asdsadasds", source: nil)

    response.status_code.should eq(200)
    domain.events!.size.should eq(1)
    domain.sessions!.size.should eq(1)
  end

  it "events ignored if bot" do
    domain = DomainBox.create

    domain.events!.size.should eq(0)

    response = AppClient.exec(Events::Create, domain: domain.address, user_agent: "DuckDuckBot/1.0; (+http://duckduckgo.com/duckduckbot.html)", referrer: nil, url: "https://#{domain.address}/", source: nil)

    response.status_code.should eq(200)
    domain.events!.size.should eq(0)
    domain.sessions!.size.should eq(0)
  end
end
