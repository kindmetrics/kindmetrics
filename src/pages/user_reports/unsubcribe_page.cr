class UserReports::UnsubscribePage < AuthLayout
  def content
    div class: "card" do
      h2 "Unsubscribed", class: "text-xl"
      para "We have removed you. You should not get another email."
    end
  end
end
