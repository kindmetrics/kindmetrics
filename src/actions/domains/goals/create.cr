class Domains::Goals::Create < BrowserAction
  post "/domins/:domain_id/goals" do
    domain = DomainQuery.new.user_id(current_user.id).find(domain_id)
    DomainPolicy.update_not_found?(domain, current_user, context)
    SaveGoal.create(params, domain_id: domain.id, sort: 1) do |operation, goal|
      if goal
        flash.success = "The record has been saved"
        redirect Domains::EditGoals.with(domain.id)
      else
        flash.failure = "It looks like the form is not valid"
        redirect Domains::EditGoals.with(domain.id)
      end
    end
  end
end
