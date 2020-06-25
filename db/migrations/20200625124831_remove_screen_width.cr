class RemoveScreenWidth::V20200625124831 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Session) do
      remove :screen_width
    end
    alter table_for(Event) do
      remove :screen_width
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
