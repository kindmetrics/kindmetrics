class AddDomainsToEvent::V20200514143943 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Event) do
      add_belongs_to domain : Domain, on_delete: :cascade
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
