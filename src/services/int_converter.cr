module JSON::IntConverter(Converter)
  def self.from_json(value : JSON::PullParser) : Int64
    value.read_string.to_i64
  end

  def self.to_json(value : Int64, builder : JSON::Builder)
    value.to_json(builder)
  end
end
