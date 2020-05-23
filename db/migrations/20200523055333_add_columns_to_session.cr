class AddColumnsToSession::V20200523055333 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Session) do
      add path : String?
      add device : String?
      add operative_system : String?
      add referrer_domain : String?
      add source : String?
    end
    make_optional :sessions, :url
    make_optional :sessions, :user_agent
  end

  def rollback
    # drop table_for(Thing)
  end
end
