class Domains::Create < BrowserAction
  include TrialCheck
  route do
    SaveDomain.create(params, user_id: current_user.id, current_user: current_user) do |operation, domain|
      if domain
        flash.success = "The record has been saved"
        redirect Show.with(domain.id)
      else
        flash.failure = "It looks like the form is not valid"
        html NewPage, operation: operation
      end
    end
  end
end
