class TrialComponent < BaseComponent
  needs current_user : User

  def render
    link to: Users::Billing, class: "inline-block border border-red-800 text-red-800 rounded bg-red-100 font-semibold p-2 mr-2" do
      if time_span.days < 1
        text "Upgrade now"
      else
        text "Trial ends in #{pluralize(time_span.days, "day")}"
      end
    end
  end

  def time_span
    current_user.not_nil!.trial_ends_at - Time.utc
  end
end
