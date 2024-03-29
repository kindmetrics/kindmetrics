require "../../../spec_helper"

describe Api::Domains::Show do
  before_each do
    AddClickhouse.clean_database
  end
  after_each do
    AddClickhouse.clean_database
  end

  it "see specific domain" do
    token = ApiTokenFactory.create

    domain = DomainFactory.create &.user_id(token.user_id)

    response = ApiClient.auth(token).exec(Api::Domains::Show.with(domain.id))
    response.status_code.should eq(200)
    response.body.should contain(domain.address)
  end

  it "get error if user do not own domain" do
    token = ApiTokenFactory.create

    domain = DomainFactory.create

    response = ApiClient.auth(token).exec(Api::Domains::Show.with(domain.id))
    response.status_code.should eq(404)
    response.body.should_not contain(domain.address)
  end

  it "get error if user do not own domain" do
    user = UserFactory.create &.trial_ends_at(5.days.ago)
    token = ApiTokenFactory.create &.user_id(user.id)

    domain = DomainFactory.create &.user_id(user.id)

    response = ApiClient.auth(token).exec(Api::Domains::Show.with(domain.id))
    response.status_code.should eq(403)
    response.body.should_not contain(domain.address)
  end
end
