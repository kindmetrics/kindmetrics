require "../../../spec_helper"

describe Api::Domains::Goals::Index do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see empty goals list for domain" do
    token = ApiTokenFactory.create

    domain = DomainFactory.create &.user_id(token.user_id)

    response = ApiClient.auth(token).exec(Api::Domains::Goals::Index.with(domain.id))
    response.status_code.should eq(200)
    test_array = [] of String
    response.body.should eq(test_array.to_json)
  end

  it "see 1 in goals list for domain" do
    token = ApiTokenFactory.create

    domain = DomainFactory.create &.user_id(token.user_id)

    goal = GoalFactory.create &.domain_id(domain.id)

    response = ApiClient.auth(token).exec(Api::Domains::Goals::Index.with(domain.id))
    response.status_code.should eq(200)
    response.body.should contain(goal.name)
    response.body.should contain("Path")
  end
end
