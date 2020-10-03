module SettingsTabs
  macro included
    quick_def links, [
      {"link" => Users::Edit.url, "name" => "Settings", "icon" => "settings"},
      {"link" => Users::Billing.url, "name" => "Billing", "icon" => "billing"},
      {"link" => Users::ApiTokens::Index.url, "name" => "Api Tokens", "icon" => "tokens"},
    ]
  end
end
