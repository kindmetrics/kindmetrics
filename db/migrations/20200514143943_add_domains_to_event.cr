class AddDomainsToEvent::V20200514143943 < Avram::Migrator::Migration::V1
  def migrate
    alter :events do
      add_belongs_to domain : Domain, on_delete: :cascade
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
