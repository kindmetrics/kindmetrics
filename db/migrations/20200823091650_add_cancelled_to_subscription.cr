class AddCancelledToSubscription::V20200823091650 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Subscription) do
      add cancelled : Bool, default: false
    end

    alter table_for(User) do
      add trial_ends_at : Time, fill_existing_with: Time.utc + 14.days
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
