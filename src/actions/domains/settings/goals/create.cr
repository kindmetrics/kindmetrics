class Domains::Settings::Goals::Create < BrowserAction
  post "/domins/:domain_id/settings/goals" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    SaveGoal.create(params, domain_id: domain.id, sort: 1) do |_operation, goal|
      if goal
        flash.success = "The record has been saved"
        redirect to: Domains::Settings::EditGoals.with(domain.id)
      else
        flash.failure = "It looks like the form is not valid"
        redirect to: Domains::Settings::EditGoals.with(domain.id)
      end
    end
  end
end
