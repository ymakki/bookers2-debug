class ApplicationMailer < ActionMailer::Base
  # メールのデフォルト送信元アドレスを設定(応用課題9c)
  default from: 'from@example.com'
  # メールのレイアウトを 'mailer' に設定(応用課題9c)
  layout 'mailer'
end
