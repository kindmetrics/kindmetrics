class AddConfirmedToUser::V20200519101614 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add confirmed_at : Time?
      add confirmed_token : String, fill_existing_with: "test"
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
