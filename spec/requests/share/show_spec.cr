require "../../spec_helper"

describe Share::Show do
  it "Domain does not exist" do
    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: 6)

    domain_hashid = hashid.encode([345435])

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))
    response.status_code.should eq(404)
  end

  it "Domain is not shared" do
    domain = DomainBox.create &.shared(false)

    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: 6)

    domain_hashid = hashid.encode([domain.id])

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))
    response.status_code.should eq(404)
  end

  it "Get share page" do
    domain = DomainBox.create &.shared(true)
    hashid = Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: 6)

    domain_hashid = hashid.encode([domain.id])

    domain.events!.size.should eq(0)

    response = AppClient.exec(Share::Show.with(share_id: domain_hashid))

    response.status_code.should eq(200)
  end
end
