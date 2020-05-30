class UserPolicy < LuckyCan::BasePolicy

  can show, user, current_user do
    true
  end

  can update, user, current_user do
    return false if current_user.nil?
    user.id == current_user.id
  end

  can invite, user, current_user do
    return false if current_user.nil?
    user.id == current_user.id
  end
end
