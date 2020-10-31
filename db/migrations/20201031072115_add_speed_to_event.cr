class AddSpeedToEvent::V20201031072115 < Avram::Migrator::Migration::V1
  def migrate
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)

    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions ADD COLUMN page_load UInt32
    SQL
    client.execute sql

    sql = <<-SQL
    ALTER TABLE kindmetrics.events ADD COLUMN page_load UInt32
    SQL
    client.execute sql

    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions ADD COLUMN language Nullable(String)
    SQL
    client.execute sql

    sql = <<-SQL
    ALTER TABLE kindmetrics.events ADD COLUMN language Nullable(String)
    SQL
    client.execute sql
  end

  def rollback
    # drop table_for(Thing)
  end
end
