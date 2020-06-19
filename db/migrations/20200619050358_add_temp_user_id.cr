class AddTempUserId::V20200619050358 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Session) do
      add temp_user_id : String?, fill_existing_with: nil
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
