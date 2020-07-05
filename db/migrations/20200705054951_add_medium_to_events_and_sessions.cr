class AddMediumToEventsAndSessions::V20200705054951 < Avram::Migrator::Migration::V1
  def migrate
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)

    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions ADD COLUMN referrer_medium Nullable(String)
    SQL
    client.execute sql

    sql = <<-SQL
    ALTER TABLE kindmetrics.events ADD COLUMN referrer_medium Nullable(String)
    SQL
    client.execute sql
  end

  def rollback
    # drop table_for(Thing)
  end
end
