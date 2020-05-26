class RenameSourceToReferer::V20200526172654 < Avram::Migrator::Migration::V1
  def migrate
    execute <<-SQL
      ALTER TABLE events RENAME COLUMN source TO referrer_source;
    SQL
    execute <<-SQL
      ALTER TABLE sessions RENAME COLUMN source TO referrer_source;
    SQL
  end

  def rollback
    execute <<-SQL
      ALTER TABLE events RENAME COLUMN referrer_source TO source;
    SQL
    execute <<-SQL
      ALTER TABLE sessions RENAME COLUMN referrer_source TO source;
    SQL
  end
end
