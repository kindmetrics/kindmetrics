module Hashid
  def hashids
    @hashids ||= Hashids.new(salt: Lucky::Server.settings.secret_key_base, min_hash_size: 4)
  end
end
