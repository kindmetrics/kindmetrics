class Domains::New < BrowserAction
  route do
    html NewPage, operation: SaveDomain.new
  end
end
