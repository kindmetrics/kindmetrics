class AddMoreThingsToEvent::V20200516060616 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Event) do
      add path : String?
      add device : String?
      add operative_system : String?
      add referrer_domain : String?
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
