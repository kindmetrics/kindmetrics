class HTTP::PathShareGlobHandler
  include HTTP::Handler

  def call(context)
    return call_next(context) unless glob_url?(context.request.path)

    share_id, path = path_share_from_path(context.request.path)

    action = Share::Paths::Show.new(context, {"share_id" => share_id, "path" => path})
    Lucky::Log.dexter.debug { {handled_by: action.class.name.to_s} }
    action.perform_action
  end

  private def glob_url?(path)
    /^\/share\/(?<share_id>[\w]+)\/paths\/(?<path>[\w\-].*)$/.match(path)
  end

  private def path_share_from_path(path)
    match = glob_url?(path)
    return "", "" if match.nil?
    share_id = match.not_nil!["share_id"]? || ""
    path = match.not_nil!["path"]? || ""
    return share_id, path
  end
end
