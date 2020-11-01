require "csv_processor"

class UpdateIPCache < LuckyCli::Task
  summary "Update the country cache"
  name "kind.update_cache"

  def call
    IP2Country.cache_update
  end
end
