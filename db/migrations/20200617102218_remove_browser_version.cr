class RemoveBrowserVersion::V20200617102218 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Session) do
      remove :browser_version
    end
    alter table_for(Event) do
      remove :browser_version
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
