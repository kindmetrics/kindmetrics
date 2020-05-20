class IPCountry
  @@ip2country : IPGeolocation::Lookup?

  def self.country=(country)
    @@ip2country = country
    #@@ip2country.not_nil!.build_index
  end
  def self.country
    @@ip2country
  end
end
IPCountry.country = IPGeolocation::Lookup.new
