require "../../../spec_helper"

describe Api::Domains::Show do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see specific domain" do
    token = ApiTokenBox.create

    domain = DomainBox.create &.user_id(token.user_id)

    response = AppClient.auth(token).exec(Api::Domains::Show.with(domain.id))
    response.status_code.should eq(200)
    response.body.should contain(domain.address)
  end
end
