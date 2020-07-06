class ReferrerMainComponent < BaseComponent
  needs event : StatsReferrer
  needs index : Int32
  needs current_user : User?
  needs current_domain : Domain
  needs period : String

  def render
    tr class: index.odd? ? "bg-gray-200" : "bg-white" do
      td class: "w-4/6 py-2" do
        if !event.referrer_domain.nil? && event.referrer_domain.not_nil! == current_domain.address
          text "(direct)"
        else
          a class: "block px-2 hover:underline", href: current_user.nil? ? Share::Referrer::Show.with(current_domain.hashid, event.referrer_source.to_s, period.to_s).url : Domains::Referrer::Show.with(current_domain.hashid, event.referrer_source.to_s, period.to_s).url do
            img src: "https://api.faviconkit.com/#{event.referrer_domain}/16", class: "inline align-middle mr-2 h-4 w-4 -mt-px"
            text (event.referrer_source || event.referrer_domain).to_s
          end
        end
      end
      td class: "w-1/6 py-2" do
        text event.bounce_rate.to_s + "%"
      end
      td class: "w-1/6 py-2" do
        text event.count.to_s
      end
    end
  end
end
