class CreateSessions::V20200523042748 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create :sessions do
      primary_key id : Int64
      add_belongs_to domain : Domain, on_delete: :cascade
      add user_id : String
      add referrer : String?
      add domain : String?
      add url : String?
      add user_agent : String?
      add screen_width : String?
      add browser_name : String?
      add browser_version : String?
      add country : String?
      add length : Int64? # in seconds
      add is_bounce : Bool, default: true
      add_timestamps
    end
  end

  def rollback
    drop :sessions
  end
end
