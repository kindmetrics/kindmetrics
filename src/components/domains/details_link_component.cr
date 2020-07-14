class DetailsLinkComponent < BaseComponent
  needs link : String

  def render
    div class: "text-center w-full absolute bottom-0 left-0 pt-2 pb-1" do
      a href: link, class: "uppercase text-sm" do
        text "Details"
      end
    end
  end
end
