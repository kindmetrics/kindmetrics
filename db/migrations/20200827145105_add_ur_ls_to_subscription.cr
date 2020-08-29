class AddURLsToSubscription::V20200827145105 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Subscription) do
      add update_url : String, fill_existing_with: "none"
      add cancel_url : String, fill_existing_with: "none"
    end
  end

  def rollback
    alter table_for(Subscription) do
      remove :update_url
      remove :cancel_url
    end
  end
end
