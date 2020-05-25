class DomainPolicy < LuckyCan::BasePolicy

  can show, domain, current_user do
    return false if current_user.nil?
    current_user.id == domain.user_id
  end

  can show_share, domain, current_user do
    return false if !domain.shared? && current_user.nil?
    return domain.shared?
  end

  can update, domain, current_user do
    return false if current_user.nil?
    current_user.id == domain.user_id
  end

  can delete, domain, current_user do
    return false if current_user.nil?
    current_user.id == domain.user_id
  end

end
