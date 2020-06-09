class TimezoneDropdown(T) < BaseComponent
  needs time_zone : Avram::PermittedAttribute(T)

  def render
    label_for(time_zone, class: "label")
    div class: "inline-block relative w-full my-2" do
      select_input(time_zone, class: "block appearance-none w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor") do
        options_for_select(time_zone, TIMEZONES.map { |t| {t, t} })
      end
      div class: "pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700" do
        raw <<-SVG
        <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
        SVG
      end
    end
  end
end
