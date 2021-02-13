class GoalFactory < Avram::Factory
  def initialize
    name "/sign_up"
    kind 1
    sort 0
    domain_id DomainFactory.create.id
  end
end
