class Domains::New < BrowserAction
  route do
    html NewPage, operation: SaveDomain.new(current_user: current_user)
  end
end
