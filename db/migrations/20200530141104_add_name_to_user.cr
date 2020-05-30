class AddNameToUser::V20200530141104 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add name : String?
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
