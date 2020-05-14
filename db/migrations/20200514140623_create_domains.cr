class CreateDomains::V20200514140623 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Domain) do
      primary_key id : Int64
      add address : String, unique: true
      add time_zone : String
      add_belongs_to user : User, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop table_for(Domain)
  end
end
