class CreateSubscription::V20200822072541 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Subscription) do
      primary_key id : Int64
      add subscription_id : String
      add next_bill_at : Time
      add checkout_id : String
      add plan_id : String
      add_belongs_to user : User, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop table_for(Subscription)
  end
end
