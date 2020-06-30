class AddClickhouseTable < LuckyCli::Task
  summary "Add the clickhouse table"
  name "kind.clickhouse"

  def initialize
    @client = Clickhouse.new
  end

  def call
    create_database
    add_events
    add_sessions
  end

  def create_database
    sql = <<-SQL
    CREATE DATABASE IF NOT EXISTS kindmetrics
    SQL
    res = @client.execute(sql)
    pp! res
  end

  def add_events
    buf = <<-SQL
    CREATE TABLE IF NOT EXISTS kindmetrics.events (
      `id` UInt64,
      `user_id` String,
      `name` String,
      `referrer` String,
      `domain` String,
      `url` String,
      `referrer_source` String,
      `path` String,
      `device` String,
      `operative_system` String,
      `referrer_domain` String,
      `browser_name` String,
      `country` String,
      `domain_id` UInt64,
      `session_id` UInt64,
      `created_at` DateTime
    )
    ENGINE = MergeTree PARTITION BY toYYYYMM(created_at) ORDER BY (user_id, created_at)
    SQL
    create = @client.execute buf
    pp! create
  end

  def add_sessions
    buf = <<-SQL
    CREATE TABLE IF NOT EXISTS kindmetrics.sessions (
      `id` UInt64,
      `user_id` String,
      `name` String,
      `referrer` String,
      `domain` String,
      `url` String,
      `referrer_source` String,
      `path` String,
      `device` String,
      `operative_system` String,
      `referrer_domain` String,
      `browser_name` String,
      `country` String,
      `domain_id` UInt64,
      `is_bounce` UInt32,
      `created_at` DateTime
    )
    ENGINE = MergeTree PARTITION BY toYYYYMM(created_at) ORDER BY (user_id, created_at)
    SQL
    create = @client.execute buf
    pp! create
  end
end
