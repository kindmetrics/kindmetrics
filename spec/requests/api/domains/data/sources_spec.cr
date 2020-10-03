require "../../../../spec_helper"

describe Api::Domains::Data::Sources do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see empty sources list for domain" do
    token = ApiTokenBox.create

    domain = DomainBox.create &.user_id(token.user_id)

    response = AppClient.auth(token).exec(Api::Domains::Data::Sources.with(domain.id))
    response.status_code.should eq(200)
    test_array = [] of String
    response.body.should eq(test_array.to_json)
  end

  it "see 1 in sources list for domain" do
    token = ApiTokenBox.create

    domain = DomainBox.create &.user_id(token.user_id)

    EventHandler.create_session(user_id: "gsddddddr", name: "pageview", referrer: "https://indiehackers.com/amazing", referrer_domain: "indiehackers.com", url: "https://test.com/test/rrr", path: "/test/rrr", referrer_source: "indiehackers.com", referrer_medium: nil, device: "Android", browser_name: "Chrome", operative_system: "Android", country: "SE", length: 0, is_bounce: 1, domain_id: domain.id)

    response = AppClient.auth(token).exec(Api::Domains::Data::Sources.with(domain.id))
    response.status_code.should eq(200)
    response.body.should contain("indiehackers.com")
  end
end
