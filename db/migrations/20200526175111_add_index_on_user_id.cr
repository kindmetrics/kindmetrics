class AddIndexOnUserId::V20200526175111 < Avram::Migrator::Migration::V1
  def migrate
    create_index :events, [:user_id], unique: false
    create_index :events, [:created_at], unique: false
    create_index :events, [:referrer_source], unique: false
    create_index :events, [:country], unique: false
    create_index :events, [:device], unique: false
    create_index :events, [:browser_name], unique: false
    create_index :events, [:operative_system], unique: false
    create_index :sessions, [:user_id], unique: false
  end

  def rollback
    # drop table_for(Thing)
  end
end
