class Faq::DataPrivacy < BrowserAction
  include Auth::AllowGuests
  get "/data-privacy" do
    html DataPrivacyPage
  end
end
