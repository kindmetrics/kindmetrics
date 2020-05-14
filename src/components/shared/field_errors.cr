class Shared::FieldErrors(T) < BaseComponent
  needs attribute : Avram::PermittedAttribute(T)

  # Customize the markup and styles to match your application
  def render
    unless attribute.valid?
      div class: "error" do
        text "#{label_text} #{attribute.errors.first}"
      end
    end
  end

  def label_text : String
    Wordsmith::Inflector.humanize(attribute.name.to_s)
  end
end
