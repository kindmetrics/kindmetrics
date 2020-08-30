class RenderKindTracker < BrowserAction
  include Auth::AllowGuests

  get "/js/kind.js" do
    if KindEnv.env("APP_HOST").nil?
      return head 412
    end
    if KindEnv.env("TRACK_PUBLIC") == "1" || KindEnv.env("TRACK_PUBLIC") == "true"
      file_content = File.read("#{Dir.current}/public/kind.js")
      return send_text_response file_content, "text/javascript", 200
    end
    file = JavascriptStorage.get("kind.js")
    file_content = file.gets_to_end

    pre = file_content.gsub("KINDURL", "\"//#{KindEnv.env("APP_HOST")}\"")
    send_text_response pre, "text/javascript", 200
  end
end
