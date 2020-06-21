class UserBox < Avram::Box
  def initialize
    name sequence("name")
    email "#{sequence("test-email")}@example.com"
    encrypted_password Authentic.generate_encrypted_password("password")
    confirmed_token Random::Secure.hex(32)
    confirmed_at Time.utc
    admin false
  end
end
