class Notification < ApplicationRecord
  # ↓ 【Rails】通知機能を実装してみよう

  # モデルの中でxxx_pathメソッドを使用するために必要な記述になります。
  include Rails.application.routes.url_helpers

  belongs_to :user

  # ポリモーフィック関連として設定され、複数のNotifiableモデルに属することを設定しています
  belongs_to :notifiable, polymorphic: true

  # 通知欄に表示するメッセージを作成
  def message
    notifiable.notification_message
  end

  # 通知を既読にした後のリダイレクト先を決める
  def notifiable_path
    notifiable.notification_path
  end

end
