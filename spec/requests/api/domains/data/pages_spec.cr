require "../../../../spec_helper"

describe Api::Domains::Data::Pages do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see empty pages list for domain" do
    token = ApiTokenBox.create

    domain = DomainBox.create &.user_id(token.user_id)

    response = AppClient.auth(token).exec(Api::Domains::Data::Pages.with(domain.id))
    response.status_code.should eq(200)
    test_array = [] of String
    response.body.should eq(test_array.to_json)
  end
end
