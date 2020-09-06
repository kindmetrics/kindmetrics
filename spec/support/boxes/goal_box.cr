class GoalBox < Avram::Box
  def initialize
    name "/sign_up"
    kind 1
    sort 0
    domain_id DomainBox.create.id
  end
end
