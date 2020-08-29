class DomainPolicy < LuckyCan::BasePolicy
  extend SubscriptionCheck

  can show, domain, current_user do
    return false if current_user.nil?
    return false if !check_subscription(domain.user!)
    current_user.id == domain.user_id
  end

  can show_share, domain, current_user do
    return false if !check_subscription(domain.user!)
    return false if !domain.shared && current_user.nil?
    return true if !current_user.nil? && current_user.id == domain.user_id
    domain.shared
  end

  can update, domain, current_user do
    return false if current_user.nil?
    current_user.id == domain.user_id
  end

  can delete, domain, current_user do
    return false if current_user.nil?
    current_user.id == domain.user_id
  end

  def self.check_subscription(user)
    return true if user.trial_ends_at > Time.utc
    return true if user.admin?
    subscription = user.subscription!
    return false if subscription.nil?
    return false if subscription_time?(subscription)
    return true
  end
end
