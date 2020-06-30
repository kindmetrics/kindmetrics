class AddClickhouse

  def self.event_insert(user_id, name, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id, session_id)
    client = Clickhouse.new

    created_at = Time.local
    id = Random.new.rand(UInt64)

    json_object = {
      id: id,
      user_id: user_id,
      name: name,
      url: url,
      referrer_source: referrer_source,
      path: path,
      device: device,
      operative_system: operative_system,
      referrer_domain: referrer_domain,
      browser_name: browser_name,
      country: country,
      domain_id: domain_id,
      session_id: session_id,
      created_at: created_at.to_s("%Y-%m-%d %H:%M:%S")
    }

    buf = <<-SQL
    INSERT INTO kindmetrics.events FORMAT JSONEachRow #{json_object.to_json}
    SQL

    client.insert buf
  end

  def self.session_insert(user_id, length : Int64?, is_bounce : Int32, referrer, url, referrer_source, path, device, operative_system, referrer_domain, browser_name, country, domain_id)
    client = Clickhouse.new

    created_at = Time.local
    id = Random.new.rand(UInt64)

    json_object = {
      id: id,
      user_id: user_id,
      length: length,
      is_bounce: is_bounce,
      url: url,
      referrer_source: referrer_source,
      path: path,
      device: device,
      operative_system: operative_system,
      referrer_domain: referrer_domain,
      browser_name: browser_name,
      country: country,
      domain_id: domain_id,
      created_at: created_at.to_s("%Y-%m-%d %H:%M:%S")
    }

    buf = <<-SQL
    INSERT INTO kindmetrics.sessions FORMAT JSONEachRow #{json_object.to_json}
    SQL

    result = client.insert buf
    result
  end

  def self.get_session(user_id) : Int64
    client = Clickhouse.new
    sql = <<-SQL
    SELECT id FROM kindmetrics.sessions WHERE user_id='#{user_id}' AND length IS NULL ORDER BY created_at DESC
    SQL
    res = client.execute sql
    maps = res.map(id: UInt64)
    maps.first["id"].to_i64
  end

  def self.get_last_event(session_id) : Array(NamedTuple(id: UInt64, created_at: Time))
    client = Clickhouse.new
    sql = <<-SQL
    SELECT id, created_at FROM kindmetrics.events WHERE session_id=#{session_id} ORDER BY created_at DESC
    SQL
    res = client.execute sql
    res.map(id: UInt64, created_at: Time)
  end
end
