class StatsDevice
  DB.mapping({
    device:     String?,
    count:      Int64,
    percentage: Float32?,
  })
end
