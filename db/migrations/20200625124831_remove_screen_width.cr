class RemoveScreenWidth::V20200625124831 < Avram::Migrator::Migration::V1
  def migrate
    alter :sessions do
      remove :screen_width
    end
    alter :events do
      remove :screen_width
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
