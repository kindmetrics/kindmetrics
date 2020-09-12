class RemoveUsersWithUrlInName::V20200912040045 < Avram::Migrator::Migration::V1
  def migrate
    users = UserQuery.new.confirmed_at.is_nil
    users.each do |u|
      next if u.name.nil?
      if no_url_in_name(u.name.not_nil!)
        u.delete
      end
    end
  end

  def rollback
    # drop table_for(Thing)
  end

  def no_url_in_name(name : String) :  Bool
    matched = /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/.match(name)
    !matched.nil?
  end
end
