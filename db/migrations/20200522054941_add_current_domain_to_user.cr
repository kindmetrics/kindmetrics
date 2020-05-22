class AddCurrentDomainToUser::V20200522054941 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add_belongs_to current_domain : Domain?, on_delete: :cascade
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
