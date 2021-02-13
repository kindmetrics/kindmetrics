class DomainFactory < Avram::Factory
  def initialize
    address sequence("kindmetrics.io")
    time_zone "Europe/Stockholm"
    user_id UserBox.create.id
    shared false
  end
end
