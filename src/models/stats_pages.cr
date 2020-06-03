class StatsPages
  DB.mapping({
    address:    String?,
    count:      Int64,
    percentage: Float32?,
  })
end
