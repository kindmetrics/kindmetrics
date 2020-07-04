class FixedSessionsMark::V20200704085318 < Avram::Migrator::Migration::V1
  def migrate
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)

    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions ADD COLUMN mark UInt8
    SQL
    client.execute sql

    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions UPDATE mark=1 WHERE length IS NOT NULL
    SQL
    client.execute sql
  end

  def rollback
    # drop table_for(Thing)
  end
end
