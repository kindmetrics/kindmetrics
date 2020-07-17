class RenderTracker < BrowserAction
  include Auth::AllowGuests

  get "/js/track.js" do
    if KindEnv.env("APP_HOST").nil?
      return head 414
    end
    if KindEnv.env("TRACK_PUBLIC") == "1" || KindEnv.env("TRACK_PUBLIC") == "true"
      file_content = File.read("#{Dir.current}/public/track.js")
      return send_text_response file_content, "text/javascript", 200
    end
    file = JavascriptStorage.get("track.js")
    file_content = file.gets_to_end

    pre = file_content.gsub("KINDURL", "\"//#{KindEnv.env("APP_HOST")}\"")
    send_text_response pre, "text/javascript", 200
  end
end
