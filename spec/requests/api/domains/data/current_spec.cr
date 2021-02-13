require "../../../../spec_helper"

describe Api::Domains::Data::Current do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see zero current for domain" do
    token = ApiTokenFactory.create

    domain = DomainFactory.create &.user_id(token.user_id)

    response = ApiClient.auth(token).exec(Api::Domains::Data::Current.with(domain.id))
    response.status_code.should eq(200)
    response.body.should contain("0")
  end
end
