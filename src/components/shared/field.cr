# This component is used to make it easier to render the same fields styles
# throughout your app.
#
# Extensive documentation at: https://luckyframework.org/guides/frontend/html-forms#shared-components
#
# ## Basic usage:
#
#    # Renders a text input by default and will guess the label name "Name"
#    m Shared::Field.new(op.name)
#    # Call any of the input methods on the block
#    m Shared::Field.new(op.email), &.email_input
#    # Add other HTML attributes
#    m Shared::Field.new(op.email), &.email_input(autofocus: "true")
#    # Pass an explicit label name
#    m Shared::Field.new(op.username, "Your username")
#
# ## Customization
#
# You can customize this component so that fields render like you expect.
# For example, you might wrap it in a div with a "field-wrapper" class.
#
#    div class: "field-wrapper"
#      label_for field
#      yield field
#      m Shared::FieldErrors.new(field)
#    end
#
# You may also want to have more components if your fields look
# different in different parts of your app, e.g. `CompactField` or
# `InlineTextField`
class Shared::Field(T) < BaseComponent
  # Raises a helpful error if component receives an unpermitted attribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?

  def render
    label_for attribute, label_text, class: "label"

    # You can add more default options here. For example:
    #
    #    with_defaults field: attribute, class: "input"
    #
    # Will add the class "input" to the generated HTML.
    with_defaults field: attribute do |input_builder|
      yield input_builder
    end

    m Shared::FieldErrors, attribute
  end

  # Use a text_input by default
  def render
    render &.text_input(append_class: "w-full bg-white text-gray-900 focus:bg-white border border-gray-400 hover:border hover:border-blue-500 focus:text-black rounded p-2 my-2 leading-tight transistor")
  end
end
