module Lucky::HTMLBuilder
  macro render_template(template)
    Kilt.embed "src/pages/{{template.id}}.html.ecr", io_name: view
  end
end
