class StatsReferrer
  DB.mapping({
    referrer_source: String?,
    count: Int64,
    percentage: Float32?
  })
end
