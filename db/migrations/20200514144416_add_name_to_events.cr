class AddNameToEvents::V20200514144416 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Event) do
      add name : String, fill_existing_with: :nothing
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
