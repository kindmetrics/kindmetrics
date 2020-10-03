class CreateApiTokens::V20200926071613 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(ApiToken) do
      add token : String
      add_belongs_to user : User, on_delete: :cascade
      primary_key id : Int64
      add_timestamps
    end
  end

  def rollback
    drop table_for(ApiToken)
  end
end
