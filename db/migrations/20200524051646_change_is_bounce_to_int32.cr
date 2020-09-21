class ChangeIsBounceToInt32::V20200524051646 < Avram::Migrator::Migration::V1
  def migrate
    alter :sessions do
      remove :is_bounce
      add is_bounce : Int32, fill_existing_with: 1
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
