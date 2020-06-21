class CreateReportUsers::V20200610110813 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(ReportUser) do
      primary_key id : Int64
      add_belongs_to domain : Domain, on_delete: :cascade
      add email : String
      add weekly : Bool, default: false
      add monthly : Bool, default: false
      add_timestamps
    end
  end

  def rollback
    drop table_for(ReportUser)
  end
end
