class FindCountry
  def initialize
    @countries = YAML.parse(File.read("#{Dir.current}/cache/countries.yml"))
  end

  def find_by_cc(cc : String)
    @countries["country"].as_a.find { |c| c["iso2"].as_s == cc }
  end
end
