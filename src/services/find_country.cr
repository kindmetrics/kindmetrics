class FindCountry
  def initialize
    @countries = YAML.parse(File.read("#{Dir.current}/cache/countries.yml"))
  end

  def find_by_cc(cc : String)
    @countries["country"].as_a.each { |c| return c if c["iso2"].as_s == cc }
  end
end
