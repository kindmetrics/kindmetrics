class DeleteEventSessions::V20200921053016 < Avram::Migrator::Migration::V1
  def migrate
    drop :events
    drop :sessions
  end

  def rollback
    # drop table_for(Thing)
  end
end
