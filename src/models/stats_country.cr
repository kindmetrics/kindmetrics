class StatsCountry
  DB.mapping({
    country:      String?,
    country_name: String?,
    count:        Int64,
    percentage:   Float32?,
  })
end
