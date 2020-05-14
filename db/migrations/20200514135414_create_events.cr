class CreateEvents::V20200514135414 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Event) do
      primary_key id : Int64
      add user_id : String
      add referrer : String?
      add domain : String?
      add url : String?
      add source : String?
      add user_agent : String?
      add screen_width : String?
      add browser_name : String?
      add browser_version : String?
      add_timestamps
    end
  end

  def rollback
    drop table_for(Event)
  end
end
