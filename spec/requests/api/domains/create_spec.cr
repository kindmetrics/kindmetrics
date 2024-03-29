require "../../../spec_helper"

describe Api::Domains::Create do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "create domain for user" do
    token = ApiTokenFactory.create

    user = token.user!

    user.domains!.size.should eq(0)

    response = ApiClient.auth(token).exec(Api::Domains::Create, domain: {address: "microgit.com", time_zone: "Europe/Stockholm"})
    response.status_code.should eq(201)

    user.reload
    user.domains!.size.should eq(1)

    domain = user.domains!.first

    domain.address.should eq("microgit.com")
  end
end
