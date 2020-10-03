class Users::ApiTokens::IndexPage < SettingsLayout
  quick_def enable_paddle, true
  quick_def page_title, "Api Tokens"
  needs tokens : ApiTokenQuery

  include SettingsTabs

  quick_def active, "Api Tokens"
  quick_def tab, true

  def content
    div class: "max-w-2xl mx-auto" do
      render_tokens
      link "Create new Token", to: Users::ApiTokens::Create, class: "rounded p-2 bg-blue-600 text-white hover:bg-blue-400 transistor"
    end
  end

  def render_tokens
    return render_empty if tokens.clone.select_count == 0
    div class: "overflow-hidden border border-kind-gray rounded mb-4" do
      table class: "min-w-full divide-y divide-gray-200" do
        thead do
          tr do
            th class: "px-6 py-3 bg-gray-50 text-left text-xs leading-4 font-medium text-gray-500 uppercase tracking-wider", colspan: 2 do
              text "Token"
            end
          end
        end
        tbody class: "bg-white divide-y divide-gray-200" do
          tokens.each do |token|
            tr do
              td class: "px-6 py-4 whitespace-no-wrap text-sm leading-5 font-medium" do
                text token.token
              end
              td class: "px-6 py-4 whitespace-no-wrap text-right text-sm leading-5 font-medium" do
                link "Delete", to: Users::ApiTokens::Delete.with(token.id), method: "delete", data_confirm: "Sure you want to delete this token?", class: "text-indigo-600 hover:text-indigo-900"
              end
            end
          end
        end
      end
    end
  end

  def render_empty
    div class: "w-full py-10 text-center leading-5 font-medium rounded bg-white border border-kind-gray mb-4" do
      text "No tokens yet"
    end
  end
end
