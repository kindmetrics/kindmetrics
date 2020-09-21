class RemoveUserAgentFromEventAndSession::V20200606135243 < Avram::Migrator::Migration::V1
  def migrate
    alter :sessions do
      remove :user_agent
    end
    alter :events do
      remove :user_agent
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
