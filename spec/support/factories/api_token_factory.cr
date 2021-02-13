class ApiTokenFactory < Avram::Factory
  def initialize
    token Random::Secure.hex(32)
    user_id UserBox.create.id
  end
end
