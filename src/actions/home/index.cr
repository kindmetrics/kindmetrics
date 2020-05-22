class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    if current_user?
      if current_user.not_nil!.current_domain.nil?
        domain = DomainQuery.new.user_id(current_user.not_nil!.id).first
        if domain.nil?
          redirect Domains::New
        else
          redirect Domains::Show.with(domain)
        end
      else
        redirect Domains::Show.with(current_user.not_nil!.current_domain.not_nil!)
      end
    else
      # When you're ready change this line to:
      #
      #   redirect SignIns::New
      #
      # Or maybe show signed out users a marketing page:
      #
      #   html Marketing::IndexPage
      html IndexPage
    end
  end
end
