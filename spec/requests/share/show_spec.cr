require "../../spec_helper"

describe Share::Show do
  it "Domain does not exist" do
    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)

    domain_hashid = hashid.encode([345435])

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))
    response.status_code.should eq(404)
  end

  it "Domain is not shared" do
    domain = DomainBox.create &.shared(false)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))
    response.status_code.should eq(404)
  end

  it "Get share page" do
    domain = DomainBox.create &.shared(true)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end

  it "block if trial is ended" do
    user = UserBox.create &.trial_ends_at Time.utc - 1.day
    domain = DomainBox.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(404)
  end

  it "allow if using subscription" do
    user = UserBox.create &.trial_ends_at Time.utc - 1.day
    subscription = SubscriptionBox.create &.user_id(user.id)
    domain = DomainBox.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end

  it "allow if subscription is cancelled and still valid date" do
    user = UserBox.create &.trial_ends_at Time.utc - 1.day
    subscription = SubscriptionBox.create &.user_id(user.id).cancelled(true).next_bill_at(Time.utc + 2.days)
    domain = DomainBox.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end

  it "block if subscription is cancelled and past due" do
    user = UserBox.create &.trial_ends_at Time.utc - 1.day
    subscription = SubscriptionBox.create &.user_id(user.id).cancelled(true).next_bill_at(Time.utc - 2.days)
    domain = DomainBox.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(404)
  end

  it "allow if admin" do
    user = UserBox.create &.trial_ends_at(Time.utc - 1.day).admin(true)
    domain = DomainBox.create &.shared(true).user_id(user.id)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: HASHID_MIN_LENGTH)
    domain_hashid = hashid.encode([domain.id])

    domain.events.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end
end
