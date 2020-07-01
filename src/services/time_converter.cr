module JSON::ClickTimeConverter(Converter)
  def self.from_json(value : JSON::PullParser) : Time
    Time.parse(value.read_string.gsub(">>", ""), "%Y-%m-%d %H:%M:%S", Time::Location::UTC)
  end
  def self.to_json(value : Time, builder : JSON::Builder)
    value.to_json(builder)
  end
end
