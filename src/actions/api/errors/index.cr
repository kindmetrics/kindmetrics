class Errors::Index < ApiAction
  include Api::Auth::SkipRequireAuthToken
  get "/api/error" do
    Log.debug { { error: params.get("message") } }
    head :ok
  end
end
