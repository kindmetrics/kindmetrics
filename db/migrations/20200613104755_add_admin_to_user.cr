class AddAdminToUser::V20200613104755 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add admin : Bool, default: false
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
