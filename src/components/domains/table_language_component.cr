class TableLanguageComponent < BaseComponent
  needs event : StatsLanguage
  needs index : Int32

  def render
    tr class: index.odd? ? "bg-gray-100" : "bg-white" do
      td class: "w-4/6 p-2" do
        text event.language.to_s
      end
      td class: "w-2/6 p-2" do
        text event.count.to_s
      end
    end
  end
end
