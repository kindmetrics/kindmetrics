class ApiTokenFactory < Avram::Factory
  def initialize
    token Random::Secure.hex(32)
    user_id UserFactory.create.id
  end
end
