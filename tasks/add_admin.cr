class AddAdmin < LuckyCli::Task
  summary "Make user admin"
  name "kind.admin"

  def call(args = ARGV)
    email = args.first
    user = UserQuery.new.email(email).first
    SaveUser.update!(user, admin: true)
    puts "Made #{user.email} admin"
  end
end
