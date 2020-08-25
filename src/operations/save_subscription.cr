class SaveSubscription < Subscription::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/validating-saving#perma-permitting-columns
  #
  permit_columns next_bill_at, subscription_id, checkout_id
end
