class StatsReferrer
  DB.mapping({
    referrer_domain: String?,
    count: Int64
  })
end
