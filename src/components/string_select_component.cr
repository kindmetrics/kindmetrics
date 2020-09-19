class StringDropdownComponent(T) < BaseComponent
  needs selects : Array(Tuple(String, String))
  needs field : Avram::PermittedAttribute(T)

  def render
    label_for(field, class: "label")
    select_input(field, class: "w-full form-select my-2 leading-tight") do
      options_for_select(field, selects)
    end
  end
end
