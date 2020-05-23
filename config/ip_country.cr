class IPCountry
  @@ip2country : IP2Country?

  def self.country=(country)
    @@ip2country = country
  end
  def self.country
    @@ip2country
  end
end
IPCountry.country = IP2Country.new
