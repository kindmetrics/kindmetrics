class StatsBrowser
  DB.mapping({
    browser:    String?,
    count:      Int64,
    percentage: Float32?,
  })
end
