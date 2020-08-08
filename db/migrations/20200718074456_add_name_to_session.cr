class AddNameToSession::V20200718074456 < Avram::Migrator::Migration::V1
  def migrate
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)

    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions ADD COLUMN name String
    SQL
    client.execute sql
  end

  def rollback
    # drop table_for(Thing)
  end
end
