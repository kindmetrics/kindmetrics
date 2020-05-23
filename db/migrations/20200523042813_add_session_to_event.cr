class AddSessionToEvent::V20200523042813 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Event) do
      add_belongs_to session : Session?, on_delete: :cascade
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
