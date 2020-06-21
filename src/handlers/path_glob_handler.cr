class HTTP::PathGlobHandler
  include HTTP::Handler

  def call(context)
    return call_next(context) unless glob_url?(context.request.path)

    domain_id, path = domains_path_from_path(context.request.path)

    action = Domains::Paths::Show.new(context, {"domain_id" => domain_id, "path" => path})
    Lucky::Log.dexter.debug { {handled_by: action.class.name.to_s} }
    action.perform_action
  end

  private def glob_url?(path)
    /^\/domains\/(?<domain_id>[\d\-]+)\/paths\/(?<path>[\w\-].*)$/.match(path)
  end

  private def domains_path_from_path(path)
    match = glob_url?(path)
    return "", "" if match.nil?
    domain_id = match.not_nil!["domain_id"]? || ""
    path = match.not_nil!["path"]? || ""
    return domain_id, path
  end
end
