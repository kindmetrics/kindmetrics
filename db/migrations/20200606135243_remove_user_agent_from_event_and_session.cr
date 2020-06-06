class RemoveUserAgentFromEventAndSession::V20200606135243 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Session) do
      remove :user_agent
    end
    alter table_for(Event) do
      remove :user_agent
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
