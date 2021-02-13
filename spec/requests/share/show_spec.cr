require "../../spec_helper"

describe Share::Show do
  it "Domain does not exist" do
    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)

    domain_hashid = hashid.encode([345435])

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))
    response.status_code.should eq(404)
  end

  it "Domain is not shared" do
    domain = DomainFactory.create &.shared(false)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))
    response.status_code.should eq(404)
  end

  it "Get share page" do
    domain = DomainFactory.create &.shared(true)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end

  it "block if trial is ended" do
    user = UserFactory.create &.trial_ends_at Time.utc - 1.day
    domain = DomainFactory.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(404)
  end

  it "allow if using subscription" do
    user = UserFactory.create &.trial_ends_at Time.utc - 1.day
    subscription = SubscriptionFactory.create &.user_id(user.id)
    domain = DomainFactory.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end

  it "allow if subscription is cancelled and still valid date" do
    user = UserFactory.create &.trial_ends_at Time.utc - 1.day
    subscription = SubscriptionFactory.create &.user_id(user.id).cancelled(true).next_bill_at(Time.utc + 2.days)
    domain = DomainFactory.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end

  it "block if subscription is cancelled and past due" do
    user = UserFactory.create &.trial_ends_at Time.utc - 1.day
    subscription = SubscriptionFactory.create &.user_id(user.id).cancelled(true).next_bill_at(Time.utc - 2.days)
    domain = DomainFactory.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(404)
  end

  it "allow if admin" do
    user = UserFactory.create &.trial_ends_at(Time.utc - 1.day).admin(true)
    domain = DomainFactory.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = ApiClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end
end
