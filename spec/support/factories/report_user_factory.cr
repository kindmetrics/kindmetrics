class ReportUserFactory < Avram::Factory
  def initialize
    email "test@email.com"
    weekly true
    monthly true
    unsubscribed false
    unsubcribe_token sequence("unsub_token")
    domain_id DomainBox.create.id
  end
end
