class AddCountryToEvents::V20200520031001 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Event) do
      add country : String?
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
