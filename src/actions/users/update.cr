class Users::Update < BrowserAction
  put "/me" do
    SaveUser.update(current_user, params) do |operation, user|
      if operation.saved?
        flash.success = "The record has been updated"
        redirect Users::Edit
      else
        flash.failure = "It looks like the form is not valid"
        html EditPage, operation: operation
      end
    end
  end
end
