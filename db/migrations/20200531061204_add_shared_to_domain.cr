class AddSharedToDomain::V20200531061204 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Domain) do
      add shared : Bool, default: false
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
