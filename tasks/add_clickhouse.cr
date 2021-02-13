class AddClickhouseTable < LuckyCli::Task
  summary "Add the clickhouse table"
  name "kind.clickhouse"

  def initialize
    @client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
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
  end

  def add_events
    buf = <<-SQL
    CREATE TABLE IF NOT EXISTS kindmetrics.events (
      `id` UInt64,
      `user_id` String,
      `name` String,
      `domain` String,
      `url` String,
      `referrer_source` Nullable(String),
      `path` String,
      `device` Nullable(String),
      `operative_system` Nullable(String),
      `referrer_domain` Nullable(String),
      `referrer_medium` Nullable(String),
      `referrer` Nullable(String),
      `browser_name` Nullable(String),
      `country` Nullable(String),
      `language` Nullable(String),
      `page_load` UInt32,
      `domain_id` UInt64,
      `session_id` UInt64,
      `created_at` DateTime
    )
    ENGINE = MergeTree PARTITION BY toYYYYMM(created_at) ORDER BY (user_id, created_at)
    SQL
    create = @client.execute buf
  end

  def add_sessions
    buf = <<-SQL
    CREATE TABLE IF NOT EXISTS kindmetrics.sessions (
      `id` UInt64,
      `mark` UInt8,
      `user_id` String,
      `domain` String,
      `name` String,
      `url` String,
      `referrer_source` Nullable(String),
      `path` String,
      `device` Nullable(String),
      `operative_system` Nullable(String),
      `referrer_domain` Nullable(String),
      `referrer` Nullable(String),
      `referrer_medium` Nullable(String),
      `browser_name` Nullable(String),
      `country` Nullable(String),
      `language` Nullable(String),
      `page_load` UInt32,
      `domain_id` UInt64,
      `is_bounce` UInt32,
      `length` Nullable(UInt64),
      `created_at` DateTime
    )
    ENGINE = MergeTree PARTITION BY toYYYYMM(created_at) ORDER BY (user_id, created_at)
    SQL
    create = @client.execute buf
  end
end
