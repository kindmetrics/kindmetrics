class CreateGoals::V20200724052449 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Goal) do
      primary_key id : Int64
      add kind : Int32, default: 0
      add name : String
      add sort : Int32, default: 1
      add_belongs_to domain : Domain, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop table_for(Goal)
  end
end
