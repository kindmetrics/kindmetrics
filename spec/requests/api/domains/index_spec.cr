require "../../../spec_helper"

describe Api::Domains::Index do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see domains of user" do
    token = ApiTokenFactory.create

    token.user!.domains!.size.should eq(0)

    response = ApiClient.auth(token).exec(Api::Domains::Index)
    response.status_code.should eq(200)
    response.body.should_not contain("kindmetrics.io")

    domain = DomainFactory.create &.user_id(token.user_id)

    response = ApiClient.auth(token).exec(Api::Domains::Index)
    response.status_code.should eq(200)
    response.body.should contain(domain.address)
  end
end
