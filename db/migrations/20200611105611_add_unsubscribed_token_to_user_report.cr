class AddUnsubscribedTokenTOUserReport::V20200611105611 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(ReportUser) do
      add unsubcribe_token : String, fill_existing_with: Random::Secure.urlsafe_base64(32)
      add unsubscribed : Bool, default: false
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
