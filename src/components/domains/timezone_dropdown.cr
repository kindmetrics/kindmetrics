class TimezoneDropdown(T) < BaseComponent
  needs time_zone : Avram::PermittedAttribute(T)

  def render
    m StringDropdownComponent(T), selects: TIMEZONES.map { |t| {t, t} }, field: time_zone
  end
end
