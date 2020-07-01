class AddClickhouse
  def self.event_insert(user_id, name, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id, session_id)
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)

    created_at = Time.local
    id = Random.new.rand(Int64)

    json_object = {
      id:               id,
      user_id:          user_id,
      name:             name,
      url:              url,
      referrer_source:  referrer_source,
      path:             path,
      device:           device,
      operative_system: operative_system,
      referrer_domain:  referrer_domain,
      browser_name:     browser_name,
      country:          country,
      domain_id:        domain_id,
      session_id:       session_id,
      created_at:       created_at.to_s("%Y-%m-%d %H:%M:%S"),
    }

    buf = <<-SQL
    INSERT INTO kindmetrics.events FORMAT JSONEachRow #{json_object.to_json}
    SQL

    client.insert buf
  end

  def self.session_insert(user_id, length : Int64?, is_bounce : Int32, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id)
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)

    created_at = Time.local
    id = Random.new.rand(Int64)

    json_object = {
      id:               id,
      user_id:          user_id,
      length:           length,
      is_bounce:        is_bounce,
      url:              url,
      referrer_source:  referrer_source,
      path:             path,
      device:           device,
      operative_system: operative_system,
      referrer_domain:  referrer_domain,
      browser_name:     browser_name,
      country:          country,
      domain_id:        domain_id,
      created_at:       created_at.to_s("%Y-%m-%d %H:%M:%S"),
    }

    buf = <<-SQL
    INSERT INTO kindmetrics.sessions FORMAT JSONEachRow #{json_object.to_json}
    SQL

    result = client.insert buf
    result
  end

  def self.get_session(user_id) : ClickSession
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
    sql = <<-SQL
    SELECT *, toDateTime(created_at) as created_at FROM kindmetrics.sessions WHERE user_id='#{user_id}' AND length IS NULL ORDER BY created_at DESC
    SQL
    res = client.execute_as_json(sql)
    sessions = Array(ClickSession).from_json(res)
    sessions.first
  end

  def self.get_active_sessions : Array(ClickSession)
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
    sql = <<-SQL
    SELECT *, toDateTime(created_at) as created_at FROM kindmetrics.sessions WHERE length IS NULL
    SQL
    res = client.execute_as_json(sql)
    Array(ClickSession).from_json(res)
  end

  def self.get_last_event(session : ClickSession) : Array(ClickEvent)
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
    sql = <<-SQL
    SELECT *, toDateTime(created_at) as created_at FROM kindmetrics.events WHERE session_id=#{session.id} ORDER BY created_at DESC
    SQL
    res = client.execute_as_json(sql)
    Array(ClickEvent).from_json(res)
  end

  def self.get_events(session_id) : Array(ClickEvent)
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
    sql = <<-SQL
    SELECT *, toDateTime(created_at) as created_at FROM kindmetrics.events WHERE session_id=#{session_id} ORDER BY created_at ASC
    SQL
    res = client.execute_as_json(sql)
    Array(ClickEvent).from_json(res)
  end

  def self.update_session(session_id : Int64, length : Int64, is_bounce : Int32)
    client = Clickhouse.new(host: ENV["CLICKHOUSE_HOST"]?.try(&.strip), port: 8123)
    sql = <<-SQL
    ALTER TABLE kindmetrics.sessions UPDATE length = #{length}, is_bounce = #{is_bounce} WHERE id=#{session_id}
    SQL
    client.execute sql
  end
end
